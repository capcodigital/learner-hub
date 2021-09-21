/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable max-len */
import admin from "firebase-admin";
import { Request, Response, NextFunction } from "express";
import { logger } from "firebase-functions";
import * as jsend from "./jsend";

// Express middleware that validates Firebase ID Tokens passed in the Authorization HTTP header.
// The Firebase ID token needs to be passed as a Bearer token in the Authorization HTTP header like this:
// `Authorization: Bearer <Firebase ID Token>`.
// when decoded successfully, the ID Token content will be added as `req.user`.
export const validateFirebaseIdToken = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    logger.log("Check if request is authorized with Firebase ID token");

    if ((!req.headers.authorization || !req.headers.authorization.startsWith("Bearer ")) &&
        !(req.cookies && req.cookies.__session)) {
        logger.log(
            "No Firebase ID token was passed as a Bearer token in the Authorization header.",
            "Make sure you authorize your request by providing the following HTTP header:",
            "Authorization: Bearer <Firebase ID Token>",
            "or by passing a \"__session\" cookie."
        );
        res.status(401).send(jsend.error("Unauthorized"));
        return;
    }

    let idToken;
    if (req.headers.authorization && req.headers.authorization.startsWith("Bearer ")) {
        logger.log("Found \"Authorization\" header");
        // Read the ID Token from the Authorization header.
        idToken = req.headers.authorization.split("Bearer ")[1];
    } else if (req.cookies) {
        logger.log("Found \"__session\" cookie");
        // Read the ID Token from cookie.
        idToken = req.cookies.__session;
    } else {
        // No cookie
        res.status(401).send("Unauthorized");
        return;
    }

    try {
        const decodedIdToken = await admin.auth().verifyIdToken(idToken);
        logger.log("ID Token correctly decoded", decodedIdToken);
        req.user = decodedIdToken;
        next();
        return;
    } catch (error) {
        logger.error("Error while verifying Firebase ID token:", error);
        res.status(401).send("Unauthorized");
        return;
    }
};
