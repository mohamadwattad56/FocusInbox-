    import mongoose, { Document, Schema } from 'mongoose';


    // Define the interface for message document

    const singleMessageSchema = new mongoose.Schema({
        msg: { type: Object, required: true },
    });

    export interface userMessageShcema extends Document
    {
        userId: { type: String, required: true }, // Specify userId as a string
        messages: [any]
    }
    const whatsappMessages = new Schema<userMessageShcema>({
        userId: { type: String, required: true }, // Specify userId as a string
        messages: [singleMessageSchema]
    });


    // Create and export the MessageModel
    const whatsappUserModel = mongoose.model('whatsapp_messages', whatsappMessages); // Use 'users' as the collection name
    export { whatsappUserModel };
