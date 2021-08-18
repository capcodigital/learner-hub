import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
//import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./certifications";
import { getById } from "./certifications";
import { getFromFirestoreAll, getFromFirestoreByCategory, getFromConfuence } from "./generic_funs";

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

// Endpoint to return certifications from Firestore by category & subcategory

app.get("/certs", async (req: Request, res: Response) => {
    var category = req.query["category"] as string;
    var subcategory = req.query["subcategory"] as string;
    getFromFirestoreByCategory(
        category.toLowerCase(),
        subcategory.toLowerCase(),
        res);
});

// Endpoint to retrieve all certifications from firestore
app.get("/all", async (req: Request, res: Response) => {
    getFromFirestoreAll(res);
});

// Example of retrieving certifications from confluence and save then to firestore 
app.get("/example", async (req: Request, res: Response) => {
    const catalogEntry = getById(2);
    getFromConfuence(
        "haris.mexis@capco.com",
        "2Yxpj3vyhdaAmrQsM1u9CBFA",
        catalogEntry.contentUrl,
        catalogEntry.category,
        catalogEntry.subcategory,
        res);
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);