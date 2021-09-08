import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./certifications/catalog_entry";
import * as gfuns from "./generic_funs";
import {
    getUserCertifications,
} from "./firestore_funs";
import * as userFunctions from "./users/users";
import { syncAllCertifications } from "./certifications/syncCertifications";
import { initializeApp, auth } from "firebase-admin";
import { saveSkills, getUserSkills } from "./skills/skills-controller";

// Initialize Firebase app
initializeApp();

export const register = express();

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
// or by platform. Missing parameters are ignored
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud&subcategory=in%20progress
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?category=cloud
// eg. http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications?platform=aws
app.get("/certifications", async (req: Request, res: Response) => {
    var platform = req.query["platform"] as string;
    // If there's platform param, filter by platform
    if (platform != null)
        gfuns.getFromFirestoreByPlatform(platform?.toLowerCase(), res);
    else {
        // If there is no platform, filter by category & subcategory.
        // If there's no category & subcategory, will return all
        var category = req.query["category"] as string;
        var subcategory = req.query["subcategory"] as string;
        gfuns.getFromFirestoreByCategory(
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
    gfuns.describe(title, desc, res);
});

app.put("/certifications/update/rate", async (req: Request, res: Response) => {
    var certId = req.query["id"] as string;
    var rating = req.body["rating"] as number;
    gfuns.rate(certId, rating, res);
});

// Testing endpoint to execute describe put request
app.get("/putdesc", async (req: Request, res: Response) => {
    gfuns.putDescription(
        "http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications/update/describe",
        "Associate Cloud Engineer", // cert title
        "This is a great certification that will teach you many useful things", // description
        res
    );
});

// Testing endpoint to execute rate put request
app.get("/putrate", async (req: Request, res: Response) => {
    var certId = req.query["id"] as string;
    gfuns.putRating(
        "http://localhost:5001/io-capco-flutter-dev/us-central1/app/certifications/update/rate",
        certId, // cert id in firestore
        4, // rating
        res
    );
});


app.get("/skills/all", async (req: Request, res: Response) => {
    // Get userId from the query string
    const userId = req.query["userId"] as string;
    if (!userId) {
        res.status(400).send("Bad request");
    }
    else {
        try {
            const skills = await getUserSkills(userId);
            res.status(200).send(skills);
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send("Internal Server Error");
        }
    }
});

app.post("/skills", async (req: Request, res: Response) => {
    // Get userId from the query string
    functions.logger.log(`Payload for skill enfpoint: ${JSON.stringify(req.body)}`);

    const payload = req.body;

    //  Check if the payload request is well formed
    if (!payload || (payload.primarySkills == null && payload.secondarySkills == null)) {
        res.status(400).send("Bad request");
    }
    else {
        try {
            const userId = req.user?.uid;
            if (!userId) {
                functions.logger.log("User not authenticated or missing uid");
                res.status(401).send("Unauthorized");
            }
            else {
                try {
                    const primary = payload.primarySkills;
                    const secondary = payload.secondarySkills;

                    await saveSkills(userId, primary, secondary);
                    res.status(201).send("Created");
                }
                catch (error) {
                    functions.logger.log(error);
                    res.status(500).send("Internal Server Error");
                }
            }
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send("Internal Server Error")
        }
    }
});

app.put("/skills", async (req: Request, res: Response) => {
    // Get userId from the query string
    const payload = req.body;
    if (payload) {
        try {
            const userId = req.user?.uid;
            if (!userId) {
                functions.logger.log("User not authenticated or missing uid");
                res.status(401).send("Unauthorized");
            }
            else {
                try {
                    const primary = payload.primarySkills;
                    const secondary = payload.secondarySkills;

                    await saveSkills(userId, primary, secondary);
                    res.status(204).send("No Content");
                }
                catch (error) {
                    functions.logger.log(error);
                    res.status(500).send("Internal Server Error");
                }
            }
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send("Internal Server Error")
        }
    }
    else {
        res.status(400).send("Bad request");
    }
});

// Endpoint to SIGNUP a user (add in firebase auth & firestore users collection)
register.post("/users/signup", async (req: Request, res: Response) => {
    var props = req.body["properties"];
    if (props != null) userFunctions.registerUser(props, res);
    else res.send(JSON.stringify("Error"));
});

// Updates a user property in Firestore
app.put("/users/update", async (req: Request, res: Response) => {
    const uid = req.query["uid"] as string;
    const property = req.body["property"] as any;
    userFunctions.updateUser(uid, property, res);
});

// Returns all users from firestore
app.get("/users/all", async (req: Request, res: Response) => {
    return userFunctions.getUsers(res);
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);
exports.seed = functions.https.onRequest(async (req: Request, res: Response) => {
    functions.logger.log("Executing SEED. Only run this during development");

    // Create test user
    const user = await auth().createUser({
        email: "test@capco.com",
        emailVerified: true,
        password: "123456",
        displayName: "Luke Skywalker",
        disabled: false,
    });

    res.status(200).send({
        seedData: {
            user: user
        }
    });
});

exports.register = functions.https.onRequest(register);