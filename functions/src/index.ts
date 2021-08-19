import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
//import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./certifications";
import { getById } from "./certifications";
import { getFromFirestoreByCategory, getFromConfuence } from "./generic_funs";

export const app = express();
//app.use(validateFirebaseIdToken);

app.get("/hello", (req: Request, res: Response) => {
    // Sample code to test the auth middleware
    const tokenId = !req.headers.authorization || req.headers.authorization.split("Bearer ")[1];
    res.status(200).send(
        {
            token: tokenId,
            user: req.user?.name,
        }
    );
});

app.get("/catalog/:id", (req: Request, res: Response) => {
    const id = <any>req.params.id;
    const url = getUrl(id);
    res.send(url);
});

// Endpoint to return certifications from Firestore filtered by category & subcategory
// Missing parameters are ignored
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud&subcategory=in%20progress
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud
app.get("/certifications", async (req: Request, res: Response) => {
    var category = req.query["category"] as string;
    var subcategory = req.query["subcategory"] as string;
    getFromFirestoreByCategory(
        category?.toLowerCase(),
        subcategory?.toLowerCase(),
        res);
});

// Example of retrieving certifications from confluence and save then to firestore 
app.get("/example", async (req: Request, res: Response) => {
    const catalogEntry = getById(3);
    getFromConfuence(
        "haris.mexis@capco.com",
        "token here",
        catalogEntry.contentUrl,
        catalogEntry.category,
        catalogEntry.subcategory,
        res);
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);