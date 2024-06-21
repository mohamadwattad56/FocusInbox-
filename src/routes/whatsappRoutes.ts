import express, { Request, Response } from 'express';
import { process } from '../controllers/whatsappController'; // Import your process function
import { getWhatsappAuthStatus } from '../controllers/whatsappController'; // Import your process function

const router = express.Router();

// Define your route
router.post('/process',  process);
router.get('/get_status', getWhatsappAuthStatus);
export default router;