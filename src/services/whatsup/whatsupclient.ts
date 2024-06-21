import { Client, RemoteAuth } from 'whatsapp-web.js';
import {RabbitMQ, RabbitMQMessage} from "../rabbitmq/rabbitmq";
import {UserModel} from "../../mongoSchemas/userModel";
import {whatsappUserModel} from "../../mongoSchemas/messageModel";

interface ServiceCallback { (message: string, args: any): void };

export class WhatsupService
{
    userID: string;
    store?: any;
    client?: Client;
    qrCode?: string;
    authenticatied: boolean;
    callback_start?: ServiceCallback;
    rabbitMQ?: RabbitMQ;
    constructor(userID: string, store:any)
    {
        this.userID = userID;
        this.authenticatied = false;
        this.store = store ;
    }

    async startService(rabbit: RabbitMQ, callback: Function)
    {
        this.rabbitMQ = rabbit;
        console.log("startService => ");
        console.log();
        console.log("startService => Mongo DB connected!!!", this.userID);

        this.client = new Client
        (
            {
                restartOnAuthFail: false,
                puppeteer:
                    {
                        headless: true,
                        args: [
                            '--no-sandbox',
                            '--disable-setuid-sandbox'
                        ],
                    },
                authStrategy: new RemoteAuth({
                    store: this.store,
                    clientId: this.userID,
                    backupSyncIntervalMs: 300000
                }),

                webVersionCache: {
                    type: 'remote',
                    remotePath: 'https://raw.githubusercontent.com/wppconnect-team/wa-version/main/html/2.2410.1.html',
                }
            });

//
        this.client.on('qr', (qr) => {


            if (this.qrCode == null) {
                callback('qr', qr)

            }
            this.qrCode = qr;
        });

        this.client.on('disconnected', (reason) =>
        {
            console.log('disconnected ',reason);
            this.authenticatied = false;
            callback('disconnected', reason)
        });

        this.client.on('remote_session_saved',async  () =>
        {

            console.log('remote_session_saved ',this.store);
            callback('remote_session_saved', null);
        });


        this.client.on('authenticated', () =>
        {
            console.log('AUTHENTICATED');
            this.authenticatied = true;
            callback('authenticated', true);
        });


        this.client.on('auth_failure', msg => {
            this.authenticatied = false;
            console.error('AUTHENTICATION FAILURE', msg);
            callback("authenticated", false);
        });

        this.client.on('ready', () =>
        {
            console.log('Client is ready!');
        });

        this.client.on('message_create', async (msg) =>
        {
            const userId = this.userID;
            try {
                // Find the user in the 'users' MongoDB collection
                let user = await whatsappUserModel.findOne({ userId: userId });

                // If the user doesn't exist, create a new user document
                if (!user) {
                    user = new whatsappUserModel({
                        userId: userId,
                        messages: [],
                    });
                }
                //Add the new message to the user's messages array
                user.messages.push({
                    msg: msg, // Save the entire msg object
                });
                // Save the updated user document
                await user.save();
                console.log('Message saved to MongoDB:');
                var rb_msg = new RabbitMQMessage();
                rb_msg.operation = '2';
                rb_msg.id = this.userID;
                rb_msg.data.set('message', msg);
                const rb_msgString = JSON.stringify(rb_msg); // Example: Convert the whole object to a JSON string
                callback('message', rb_msgString);
            } catch (error) {
                console.log('Error saving message to MongoDB:', error);
            }
        });

        this.client.initialize();
    }



    stopService() {
        this.client?.destroy();
    }
}