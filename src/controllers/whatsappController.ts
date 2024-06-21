import { Request, Response } from 'express';
import { WhatsupService } from '../services/whatsup/whatsupclient';
import QRCode from 'qrcode';
import {wClients} from "../index";
import {PassThrough} from "stream";
const nodemailer = require('nodemailer');

const decode = (str: string): string => Buffer.from(str, 'base64').toString('binary');
const encode = (str: string): string => Buffer.from(str, 'binary').toString('base64');
import { mongoStorage,rabbitqm } from '../index';

import {RabbitMQ, RabbitMQMessage} from "../services/rabbitmq/rabbitmq";

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
