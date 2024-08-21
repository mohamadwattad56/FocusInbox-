import express, { Request, Response } from 'express';
import {process, getSummaryForConversations,getWhatsappAuthStatus,askAI} from '../../controllers/appController'; // Import your process function



const router = express.Router();

// Define your route
router.post('/process',  process);
router.post('/ask-ai',  askAI);
router.get('/get_status', getWhatsappAuthStatus);
router.get('/summary', getSummaryForConversations);


export default router;