import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import { CatalogEntry, getUrl } from "./certifications/catalog_entry";
import { getById } from "./certifications/catalog_entry";
import {
    getFromFirestoreByCategory,
    getFromConfluence,
    getFromFirestoreByPlatform,
    describe,
    rate,
    putDescription,
    putRating
} from "./generic_funs";
import { getUserCertifications } from "./firestore_funs";
import { syncAllCertifications } from "./certifications/syncCertifications";
import { initializeApp } from "firebase-admin";


// Initialize Firebase app
initializeApp();

// Initialize and configure Express server
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
        const userName = req.user?.name;
        if (userName != undefined) {
            const myCertifications = await getUserCertifications(userName);
            res.status(200).send(myCertifications);
        }
        else {
            res.status(400).send({ message: "User name cannot be empty" });
        }
    }
    catch (exception) {
        res.status(500).send({ error: exception });
    }
});

// Endpoint to return certifications from Firestore filtered either by category & subcategory
// or by platform.
// Missing parameters are ignored
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud&subcategory=in%20progress
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?platform=aws
app.get("/certifications", async (req: Request, res: Response) => {
    var platform = req.query["platform"] as string;
    // If there's platform param, filter by platform
    if (platform != null)
        getFromFirestoreByPlatform(platform?.toLowerCase(), res);
    else {
        // If there is no platform, filter by category & subcategory.
        // If there's no category & subcategory, will return all
        var category = req.query["category"] as string;
        var subcategory = req.query["subcategory"] as string;
        getFromFirestoreByCategory(
            category?.toLowerCase(),
            subcategory?.toLowerCase(),
            res);
    }
});

// Gets the certifications from Confluence, saves them to Firestore and returns them as json
app.get("/certifications/all", async (req: Request, res: Response) => {
    try {
        const data = await syncAllCertifications();
        res.status(200).send(data);
    }
    catch (error) {
        functions.logger.log(`Error when syncing all certifications: ${error}`);
        res.status(500).send();
    }
});

app.put("/certifications/update/describe", async (req: Request, res: Response) => {
    var title = req.query["title"] as string;
    var desc = req.body["desc"] as string;
    describe(title, desc, res);
});

app.put("/certifications/update/rate", async (req: Request, res: Response) => {
    var certId = req.query["id"] as string;
    var rating = req.body["rating"] as number;
    rate(certId, rating, res);
});

// Testing endpoint to execute describe put request
app.get("/putdesc", async (req: Request, res: Response) => {
    putDescription(
        "http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications/update/describe",
        "Associate Cloud Engineer", // cert title
        "This is a great certification that will teach you many useful things", // description
        res
    );
});

// Testing endpoint to execute rate put request
app.get("/putrate", async (req: Request, res: Response) => {
    var certId = req.query["id"] as string;
    putRating(
        "http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications/update/rate",
        certId, // cert id in firestore
        4, // rating
        res
    );
});

app.get("/seed", async (req: Request, res: Response) => {
    functions.logger.log("Executing SEED. Only run this during development");

    const data = await syncAllCertifications();
    res.status(200).send(data);
});

// Users:
app.get("/users/all", async (req: Request, res: Response) => {

});

app.get("/users/update", async (req: Request, res: Response) => {

});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);
