import { Request, Response } from 'express';
import { UserModel } from '../mongoSchemas/userModel';
import { process } from './appController'; // Import your process function
import { v4 as uuidv4 } from 'uuid'; // Import UUID generator

// Define a map to store UUID to token relationship

const encode = (str: string): string => Buffer.from(str, 'binary').toString('base64');

export const userInfo = async (req: Request, res: Response): Promise<void> => {
    try {
        // Extract email from request body
        const email: any = req.query.email;
        // Find the user in the database using the provided email
        const user = await UserModel.findOne({ email: email });
        if (!user) {
            // If no user is found, return a 404 response
            res.status(404).json({ error: 'User not found' });
            return;
        }

        // Retrieve the token and uuid from the user document
        const {  uuid, token, firstName, lastName } = user;

        // Construct the response object with the user's information
        const response = {
            uuid,
            token,
            username: `${firstName} ${lastName}`,
            email
        };

        // Send the response back to the client
        res.status(200).json({status:'200',message:'ok',data : response});
    } catch (error) {
        // Handle errors
        console.error('Error fetching user info:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};
export const registerUser = async (req: Request, res: Response): Promise<void> =>
{
    try {
        // Extract user data from request body
        const { firstName, lastName, email, platform, token } = req.body;
        const existingUser = await UserModel.findOne({ email });

        if (existingUser) {
            // If a user with the provided email already exists, return an error response
            res.status(400).json({ error: 'Email is already registered' });
            return; // Exit the function
        }
        // Generate UUID
        const uuid = uuidv4();
        // Store the UUID to token relationship in the map

        const newUser = new UserModel({
            uuid,
            firstName,
            lastName,
            email,
            platform,
            token
        });
        // Save the user to the database
        await newUser.save();
        // Respond with success message
        const response={status : '200',message: 'ok'}
        res.status(200).json(response);
        // Modify the request object to include the tag
        const modifiedReq: Partial<Request> = {
            ...req,
            query: { ...req.query, uuid,email } // Add the tag to the existing query parameters
        };
        process(modifiedReq as Request, res);

    } catch (error) {
        // Handle errors
        console.error('Error registering user:', error);
        res.status(500).json({ error: error });
    }
};

