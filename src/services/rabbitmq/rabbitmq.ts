
import amqp from 'amqplib/callback_api';


// import {RabbitMQ} from './rabbitmq/rabbitmq.mjs';
//import {amqp} from 'amqplib/callback_api';
export class RabbitMQMessage {
    id:String ;
    operation: string;
    data: Map<string, any>

    constructor() {
        this.id = "" ;
        this.operation = "";
        this.data = new Map<string, any>();
    }

    toJSON() {
        return {
            id:this.id,
            operation: this.operation,
            data: Object.fromEntries(this.data)
        }
    }
}

export class RabbitMQ {

    connectionString: string;
    connection?: amqp.Connection;
    channelRx?: amqp.Channel;
    channelTx?: amqp.Channel;
    assertRxQueue?: amqp.Replies.AssertQueue;
    assertTxQueue?: amqp.Replies.AssertQueue;
    rxQueue: string = 'connectx_tx';
    txQueue: string = 'connectx_rx';

    constructor(connectionString: string) {
        this.connectionString = connectionString;
    }

    start(callback: Function) {
        amqp.connect(this.connectionString, (err: any, connection: amqp.Connection) => {

            if (err != null) {
                callback.call(err);
                return;
            }
            this.connection = connection;
            this.createTxChannel((err: any) => {
                if (err != null) {
                    callback?.call(err);
                    return;
                }

                this.createRxChannel((err: any) => {
                    callback?.call(err);
                });
            });

        });
    }

    createRxChannel(callback: Function) {
        this.connection?.createChannel((err: any, channel: amqp.Channel) => {
            if (err != null) {
                callback?.call(err);
                return;
            }
            this.channelRx = channel;
            this.channelRx.assertQueue(this.rxQueue, { durable: false }, (err: any, ok: amqp.Replies.AssertQueue) => {
                if (err != null) {
                    callback?.call(err);
                    return;
                }

                this.assertRxQueue = ok;
                this.channelRx!.consume(this.rxQueue, (message) => {
                    console.log(" [x] Received %s", message?.content.toString());
                }, { noAck: true });
                callback?.call(null);

            });




        });


    }

    createTxChannel(callback: Function) {
        this.connection?.createChannel((err: any, channel: amqp.Channel) => {
            if (err != null) {
                callback?.call(err);
                return;
            }
            this.channelTx = channel;
            this.channelTx.assertQueue(this.rxQueue, { durable: false }, (err: any, ok: amqp.Replies.AssertQueue) => {
                if (err != null) {
                    callback?.call(err);
                    return;
                }

                this.assertTxQueue = ok;
                callback?.call(null);

            });
        });
    }

    send(message: string) {
        this.channelTx?.sendToQueue(this.txQueue, Buffer.from(message));
    }

}

