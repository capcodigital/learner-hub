import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import { getFromUrl } from "./generic_funs";
import { getCollection } from "./generic_funs";

export const app = express();
app.use(validateFirebaseIdToken);

app.get("/hello", (req: Request, res: Response) => {
    // Sample code to test the auth middleware
    const tokenId = !req.headers.authorization || req.headers.authorization.split("Bearer ")[1];
    res.send(
        {
            token: tokenId,
            user: req.user?.name,
        }
    );
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);

// TODO: Update logic below when we integrate catalog
// Below is example of calling the generic functions

// Retrieves the certifications from remote url, saves them and returns them as json
exports.getFromConfluence = functions.https.onRequest(async (req, res) => {
    getFromUrl('https://io-capco-flutter-dev.nw.r.appspot.com/completed', "certifications", res);
});

// Retrieves the certifications from firestore and returns them as json
exports.getFromFirestore = functions.https.onRequest(async (req, res) => {
    getCollection('certifications', res);
});