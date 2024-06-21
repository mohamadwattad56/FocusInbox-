import express, { Router } from 'express';
import {registerUser, userInfo} from '../controllers/userController';
import { getWhatsappAuthStatus } from '../controllers/whatsappController';



const router: Router = express.Router();

// Define routes for user registration
router.post('/register', registerUser);
router.get('/info', userInfo);
// Add more routes for user management

export default router;
