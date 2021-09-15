import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
//import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./certifications/catalog_entry";
import * as certifFuncs from "./certifications/certifications";
import { getUserCertifications } from "./certifications/certifications_repository";
import * as userFuncs from "./users/users";
import { syncAllCertifications } from "./certifications/syncCertifications";
import * as admin from "firebase-admin";
import { saveSkills, getUserSkills } from "./skills/skills-controller";
import * as jsend from "./jsend";

// Initialize Firebase app
admin.initializeApp();

export const register = express();

// Initialize and configure Express server
export const app = express();
//app.use(validateFirebaseIdToken);

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
            res.status(200).send(jsend.successGetCertifs(myCertifications));
        }
        else {
            res.status(400).send(jsend.error("User name cannot be empty", 400))
        }
    }
    catch (exception) {
        res.status(500).send(jsend.error("Error"));
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
        certifFuncs.getFromFirestoreByPlatform(platform?.toLowerCase(), res);
    else {
        // If there is no platform, filter by category & subcategory.
        // If there's no category & subcategory, will return all
        var category = req.query["category"] as string;
        var subcategory = req.query["subcategory"] as string;
        certifFuncs.getFromFirestoreByCategory(
            category?.toLowerCase(),
            subcategory?.toLowerCase(),
            res);
    }
});

// Gets the certifications from Confluence, saves them to Firestore and returns them as json
app.get("/certifications/all", async (req: Request, res: Response) => {
    try {
        const data = await syncAllCertifications();
        res.status(200).send(jsend.successGetCertifs(data));
    }
    catch (error) {
        functions.logger.log(`Error when syncing all certifications: ${error}`);
        res.status(500).send(jsend.error());
    }
});

app.put("/certifications/update", async (req: Request, res: Response) => {
    const title = req.query.title as string;
    const id = req.query.id as string;
    const props = req.body as any;
    certifFuncs.updateInFirestore(title, id, props, res);
});

// Testing endpoint for calling putDescription(), will be removed
app.get("/certifications/describe", async (req: Request, res: Response) => {
    certifFuncs.putDescription(
        "http://localhost:5001/io-capco-flutter-dev/europe-west2/app/certifications/update",
        "SSL/TLS Fundamentals",
        res);
});

app.get("/skills/all", async (req: Request, res: Response) => {
    // Get userId from the query string
    const userId = req.query["userId"] as string;
    if (!userId) {
        res.status(400).send(jsend.error("Bad request", 400));
    }
    else {
        try {
            const skills = await getUserSkills(userId);
            res.status(200).send(jsend.successGetSkills(skills));
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send(jsend.error());
        }
    }
});

app.post("/skills", async (req: Request, res: Response) => {
    // Get userId from the query string
    functions.logger.log(`Payload for skill enfpoint: ${JSON.stringify(req.body)}`);

    const payload = req.body;

    //  Check if the payload request is well formed
    if (!payload || (payload.primarySkills == null && payload.secondarySkills == null)) {
        res.status(400).send(jsend.error("Bad request", 400));
    }
    else {
        try {
            const userId = req.user?.uid;
            if (!userId) {
                functions.logger.log("User not authenticated or missing uid");
                res.status(401).send(jsend.error("Unauthorized", 401));
            }
            else {
                try {
                    const primary = payload.primarySkills;
                    const secondary = payload.secondarySkills;

                    await saveSkills(userId, primary, secondary);
                    res.status(201).send(jsend.success("Skills updated successfully"));
                }
                catch (error) {
                    functions.logger.log(error);
                    res.status(500).send(jsend.error("Error updating skills"));
                }
            }
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send(jsend.error("Error updating skills"));
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
                res.status(401).send(jsend.error("Unauthorized", 401));
            }
            else {
                try {
                    const primary = payload.primarySkills;
                    const secondary = payload.secondarySkills;

                    await saveSkills(userId, primary, secondary);
                    res.status(204).send(jsend.success("Skills updated successfully"));
                }
                catch (error) {
                    functions.logger.log(error);
                    res.status(500).send(jsend.error("Error updating skills"));
                }
            }
        }
        catch (error) {
            functions.logger.log(error);
            res.status(500).send(jsend.error("Error updating skills"));
        }
    }
    else {
        res.status(400).send(jsend.error("Bad request"));
    }
});

// Endpoint to SIGNUP a user (add in firebase auth & firestore users collection)
register.post("/users/signup", async (req: Request, res: Response) => {
    var props = req.body["properties"];
    if (props != null) userFuncs.registerUser(props, res);
    else res.status(400).send(jsend.error("Bad Request", 400));
});

// Updates a user property in Firestore
app.put("/users/update", async (req: Request, res: Response) => {
    const uid = req.query["uid"] as string;
    const property = req.body["property"] as any;
    userFuncs.updateUser(uid, property, res);
});

// Returns all users from firestore
app.get("/users/all", async (req: Request, res: Response) => {
    return userFuncs.getUsers(res);
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions
    .region('europe-west2') // London
    .https.onRequest(app);

exports.register = functions
    .region('europe-west2') // London
    .https.onRequest(register);