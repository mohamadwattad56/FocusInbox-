import express, { Express } from 'express';
import bodyParser from 'body-parser';
import userRoutes from "./routes/userRoutes";
import whatsappRoutes from "./routes/whatsappRoutes";


// Initialize Express app
const app: Express = express();

// Middleware
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use('/user', userRoutes,whatsappRoutes);


export { app };
