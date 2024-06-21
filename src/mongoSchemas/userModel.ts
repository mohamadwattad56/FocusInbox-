import mongoose, { Document, Schema } from 'mongoose';

// Define the interface for user document
export interface UserDocument extends Document {
    userID:string;
    firstName: string;
    lastName: string;
    email: string;
    platform: number;
    token: string;
    uuid: string;
    // Add more fields as needed
}

// Define the schema for the user
const userSchema = new Schema<UserDocument>({
    userID: { type: String },
    firstName: { type: String, required: true },
    lastName: { type: String, required: true },
    email: { type: String, unique: true },
    platform: { type: Number, required: true },
    uuid: { type: String, required: true },
    token: { type: String, required: true },

    // Define more fields and their types as needed
});


// Create and export the UserModel
export const UserModel = mongoose.model<UserDocument>('user_info', userSchema);
