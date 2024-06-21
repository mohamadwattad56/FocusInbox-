import mongoose from 'mongoose';
import { MongoStore } from 'wwebjs-mongo';
import express from 'express';
import { RabbitMQ, RabbitMQMessage } from './services/rabbitmq/rabbitmq';
import { WhatsupService } from './services/whatsup/whatsupclient';
import { app } from "./app";
const wClients = new Map<string, WhatsupService>();
let rabbitqm: RabbitMQ;
const PORT = process.env.PORT || 3000;
var mongoStorage: any;
const decode = (str: string): string => Buffer.from(str, 'base64').toString('binary');
const encode = (str: string): string => Buffer.from(str, 'binary').toString('base64');

runRabbitMQ(async (err: any) =>
{
    if (err == null) {
        await mongoose.connect("mongodb://127.0.0.1:27017/app").then(async ()=>
        {
            mongoStorage = new MongoStore({ mongoose: mongoose });
            console.log('⚡️[server]: connected to Mongo DB');
            app.listen(PORT, () => {
                console.log(`⚡️[server]: Server is running at http://localhost:${PORT}`);
            });
        }).catch((err)=>{
            console.error('Failed to connect to MongoDB', err);

        });;
    }
});
async function runRabbitMQ(callback: Function) {
    try {
        if (rabbitqm == null) {
            console.log("Starting RabbitMQ ...");
            rabbitqm = new RabbitMQ("amqp://guest:guest@localhost:5672/");
            console.log("Starting RabbitMQ rabbitqm = ", rabbitqm.connectionString);
            rabbitqm.start(function (err: Error) {
                if (err != null) {
                    console.log("RabbitMQ rabbitqm failed!", err);
                } else {
                    console.log("RabbitMQ rabbitqm UP!");
                }
                callback?.call(err);
            });
        }
    } catch (error) {
        console.log("Error to start rabbit mq", error);
    }
}
export { wClients, mongoStorage,rabbitqm };
