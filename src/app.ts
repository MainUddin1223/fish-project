import cors from 'cors';
import express, { Application, NextFunction, Request, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import config from './route/utils/config';
// import router from './route';
import globalErrorHandler from './route/utils/errorHandlers/globalErrorHandlers';

const app: Application = express();
const corsOptions = {
    origin: true,
    credentials: true,
};

app.use('*', cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// app.use(config.api_route as string, router);
app.use(globalErrorHandler);
app.get('', (req, res) => {
    const message = `Server is running `;
    res.status(StatusCodes.OK).json({
        message,
    });
});

app.use((req: Request, res: Response, next: NextFunction) => {
    res.status(StatusCodes.NOT_FOUND).json({
        success: false,
        message: 'Not found',
        errorMessages: [
            {
                path: req.originalUrl,
                message: 'API not found',
            },
        ],
    });
    next();
});

export default app;
