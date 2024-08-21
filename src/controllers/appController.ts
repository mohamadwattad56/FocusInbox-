import { Request, Response } from 'express';
import { WhatsupService } from '../services/whatsup/whatsupclient';
import QRCode from 'qrcode';
import {wClients} from "../index";
import {PassThrough} from "stream";
import axios from 'axios';

const nodemailer = require('nodemailer');

const decode = (str: string): string => Buffer.from(str, 'base64').toString('binary');
const encode = (str: string): string => Buffer.from(str, 'binary').toString('base64');
import { mongoStorage,rabbitqm } from '../index';

import {RabbitMQ, RabbitMQMessage} from "../services/rabbitmq/rabbitmq";
import {whatsappUserModel} from "../mongoSchemas/messageModel";
import {generateResponse} from "../services/ai/api";
interface AggregatedData {
    body: string;
    createdDateTime: Date;
    meetingTitle: string;
    direction: "incoming" | "outgoing";
}

interface SummarizedData {
    createdDateTime: Date;
    meetingTitle: string;
    direction: "incoming" | "outgoing";
    summary: string;
}


export async function process(req: Request, res: Response)
{
    try
    {
        const tag: any = req.query.uuid;
        const email: any = req.query.email;
        var userID = tag;
        console.log("userID  ", userID);
        var requestHandled = false ;
        if (wClients.has(userID))
        {
            console.log("User already have a valid service run  ", userID);
            if (wClients.get(userID)?.authenticatied)
            {
                console.log("User already authenticated  ", userID);
                var msg = new RabbitMQMessage();
                msg.operation = '1';
                msg.id = userID ;
                msg.data.set('authenticated', 1);
                res.send(JSON.stringify(msg));
                return;
            }
            wClients.get(userID)?.stopService();
        }

        wClients.set(userID, new WhatsupService(userID,mongoStorage));
        wClients.get(userID)?.startService(rabbitqm, async function (message: string, data: any)
        {
            if (message == 'qr')
            {
                console.log('QR RECEIVED ', data);

                try
                {
                    sendEmailWithQRCode(email, data);
                    console.log('QR code sent to user');

                } catch (err)
                {
                    console.error('Failed to return content', err);
                    var msg = new RabbitMQMessage();
                    msg.operation = '1';
                    msg.id = userID ;
                    msg.data.set('authenticated', 0);
                    msg.data.set('error', err);

                    console.error('JSON ', msg);

                    res.send(JSON.stringify(msg));
                }

                requestHandled = true ;
            }
            else
            {
                if (message == 'authenticated')
                {
                    var msg = new RabbitMQMessage();
                    msg.operation = '1';
                    msg.id = userID ;
                    msg.data.set('authenticated', data == true ? 1 : 0);
                    console.log('JSON ', msg);
                    rabbitqm.send(JSON.stringify(msg));
                    if(!requestHandled){
                        res.send(JSON.stringify(msg));
                        requestHandled = true ;
                    }

                }else if(message == 'message')
                {

                    rabbitqm.send(data);
                }

            }
        });


    } catch (error) {
        var msg = new RabbitMQMessage();
        msg.operation = '1';
        msg.id = "FATAL ERROR" ;
        msg.data.set('authenticated',  0);
        rabbitqm.send(JSON.stringify(msg));
        console.log("Error to start rabbit mq", error);
        res.send(JSON.stringify(msg));
    }

    async function sendEmailWithQRCode(email:any, qrData:any)
    {
        // Create a nodemailer transporter
        const transporter = nodemailer.createTransport({
            // Configure your email service provider here
            // For example, if you're using Gmail:
            service: 'Gmail',
            auth: {
                user: 'focuseinbox@gmail.com', // Your email address
                pass: 'kyevjmxngusmxwbk' // Your email password or app-specific password
            }
        });
        const qrStream = new PassThrough();
        await QRCode.toFileStream(qrStream, qrData, {
            type: 'png',
            width: 200,
            errorCorrectionLevel: 'H'
        });

        // Compose the email
        const mailOptions = {
            from: 'focuseinbox@gmail.com',
            to: email,
            subject: 'QR Code',
            text: 'Please find the attached QR code,Scan it using your whatsapp.',
            attachments: [{
                filename: 'qrcode.png',
                content: qrStream // Attach the QR code image stream
            }]
        };

        // Send the email
        transporter.sendMail(mailOptions, (error: any, info: { response: any; }) => {
            if (error) {
                console.error('Error sending email:', error);
            } else {
                console.log('Email sent:', info.response);
            }
        });
    }

}
export async function getWhatsappAuthStatus(req: Request, res: Response)
{
    try {
        // Extract UUID from request parameters
        const token: string | undefined = req.query.uuid as string | undefined;

        if (token === undefined) {
            res.status(400).json({ error: 'UUID query parameter is missing' });
            return;
        }
        const uuid =token;

        if (!uuid) {
            res.status(404).json({ error: 'UUID not found' });
            return;
        }
        // Check if the UUID exists in the wClients map
        if (wClients.has(uuid))
        {
            // Retrieve the corresponding WhatsupService object
            const service: WhatsupService | undefined = wClients.get(uuid);

            if (service)
            {
                console.log(service.authenticatied);
                if(service.authenticatied)
                {
                    res.status(200).json({ status: '200',message:'ok' });

                }
                else
                {
                    res.status(404).json({ error: 'UUID not found' });
                }
            }

        } else {
            // If UUID does not exist in the map, return 404 error
            res.status(404).json({ error: 'UUID not found' });
        }
    } catch (error) {
        // Handle errors
        console.error('Error fetching WhatsupService authentication status:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

export async function DataAggregator(uuid: string, from?: string): Promise<AggregatedData[]> {
    // Fetch the user's conversations from the database
    const userConversations = await whatsappUserModel.findOne({ userId: uuid });

    if (!userConversations) {
        throw new Error("User with the given UUID not found.");
    }

    const aggregatedData: AggregatedData[] = [];

    for (const conversation of userConversations.messages) {
        const message = conversation.msg._data;

        if (from) {
            // If 'from' is provided, filter messages to include only those involving 'from'
            if (message.from.user !== from && message.to.user !== from) {
                continue; // Skip messages not involving the 'from' user
            }
        }

        // Determine the direction of the message
        const direction = message.fromMe ? "outgoing" : "incoming";
        const contact = direction === "outgoing" ? message.to.user : message.from.user;

        // Add the message details to the aggregated data list
        aggregatedData.push({
            body: message.body,
            createdDateTime: new Date(message.t * 1000),  // Convert Unix timestamp to Date
            meetingTitle: contact,
            direction: direction
        });
    }

    return aggregatedData;
}

export async function summarizeConversations(uuid: string, from: string | undefined, query: string): Promise<SummarizedData[]> {
    try {
        // Fetch the aggregated data
        const data = await DataAggregator(uuid, from);

        // Create a list to hold summarized data
        const summarizedData: SummarizedData[] = [];

        // Loop through each conversation and generate a summary
        for (const item of data) {
            // Create the prompt for the AI based on the provided format
            const prompt = `Summarize the following text based on this question: Text: ${item.body} Question: "${query}".`;
            const model = 'llama-pro:latest'; // Use the appropriate model

            try {
                const response = await generateResponse(prompt, model);
                const summary = response.response;

                // Push the summarized data to the list
                summarizedData.push({
                    createdDateTime: item.createdDateTime,
                    meetingTitle: item.meetingTitle,
                    direction: item.direction,
                    summary: summary
                });
            } catch (error) {
                console.error('Error generating summary:', error);
                // Push the conversation with an error message
                summarizedData.push({
                    createdDateTime: item.createdDateTime,
                    meetingTitle: item.meetingTitle,
                    direction: item.direction,
                    summary: 'Error generating summary'
                });
            }
        }

        return summarizedData;
    } catch (error) {
        console.error('Error aggregating or summarizing data:', error);
        throw new Error('Failed to aggregate or summarize conversations');
    }
}

export async function getSummaryForConversations(req: Request, res: Response) {
    // Extract parameters from the request
    const { uuid, from, query } = req.query;

    // Validate input
    if (!uuid || typeof uuid !== 'string') {
        return res.status(400).json({ error: 'UUID is required and must be a string' });
    }

    try {
        // Call the summarizeConversations function
        const summarizedData = await summarizeConversations(uuid, from as string | undefined, query as string);

        // Return the summarized data
        res.status(200).json(summarizedData);
    } catch (error) {
        // Handle errors
        console.error('Error summarizing conversations:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
}


export async function askAI(req: Request, res: Response): Promise<void> {
    try {
        const { prompt } = req.body;

        // Validate the input
        if (!prompt) {
            res.status(400).json({ error: 'Prompt is required' });
            return;
        }

        // Forward the prompt to the AI API
        const aiResponse = await axios.post('http://85.130.185.27:11434/api/generate', {
            model: 'llama-pro:latest',
            prompt: prompt,
            stream: true
        });

        // Send the AI API response back to the client
        res.status(200).json(aiResponse.data);
    } catch (error) {
        console.error('Error communicating with AI API:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
}

