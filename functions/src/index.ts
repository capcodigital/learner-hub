import * as functions from "firebase-functions";
import admin from "firebase-admin";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./certifications";
import { getFromUrl, getCollection, getUserCertifications } from "./generic_funs";

export const app = express();
app.use(validateFirebaseIdToken);

app.get("/catalog/:id", (req: Request, res: Response) => {
    const id = <any>req.params.id;
    const url = getUrl(id);
    res.send(url);
});

app.get("/me", (req: Request, res: Response) => {
    // Sample code to test the auth middleware
    res.status(200).send(
        {
            user: req.user,
        }
    );
});

app.get("/me/certifications", async (req: Request, res: Response) => {
    try {
        const userEmail = req.user?.email;
        if (userEmail != undefined) {
            const user = await admin.auth().getUserByEmail(userEmail);
            if (user !== null) {
                const userName = user.displayName;
                if (userName != undefined) {
                    const myCertifications = await getUserCertifications(userName);
                    res.status(200).send(myCertifications);
                }
                else {
                    res.status(400).send({ message: "User name cannot be empty" });
                }
            }
            else {
                res.status(400).send({ message: "Invalid user" });
            }
        }
    } catch (exception) {
        res.status(500).send({ error: exception });
    }
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