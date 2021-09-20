import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import * as certSummaryFuncs from "./certification_summaries/certification_summary_funcs";
import * as userFuncs from "./users/users";
import * as admin from "firebase-admin";
import * as jsend from "./jsend";

// Initialize Firebase app
admin.initializeApp();

export const register = express();

// Initialize and configure Express server
export const app = express();
app.use(validateFirebaseIdToken);

// CERTIFICATION SUMMARY ENDPOINTS

// Returns all certification summaries from firestore as json
app.get("/certificationSummary", async (req: Request, res: Response) => {
    certSummaryFuncs.getAllCertificationSummaries(res);
});

// Returns a certifications by id
app.get("/certificationSummary/:id", async (req: Request, res: Response) => {
    const id = req.params.id as string;
    certSummaryFuncs.getCertificationSummary(id, res);
});

// Adds a certification summary to firestore
app.post("/certificationSummary", async (req: Request, res: Response) => {
    const summary = req.body as any;
    certSummaryFuncs.addCertificationSummary(summary, res);
});

// USER ENDPOINTS

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