import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import * as certSummaryFuncs from "./certification_summaries/certification_summary_funcs";
import * as userFuncs from "./users/user_funcs";
import * as admin from "firebase-admin";
import * as jsend from "./jsend";

// Initialize Firebase app
admin.initializeApp();

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
    if (id == null) {
        res.statusCode = 400;
        res.send(jsend.error("Bad Request"));
    } else {
        certSummaryFuncs.getCertificationSummary(id, res);
    }
});

// Adds a certification summary to firestore
app.post("/certificationSummary", async (req: Request, res: Response) => {
    const summary = req.body as any;
    certSummaryFuncs.addCertificationSummary(summary, res);
});

// USER ENDPOINTS

// Adds user in firestore
app.post("/user", async (req: Request, res: Response) => {
    const uid = req.user?.uid as string
    const user = req.body;
    if (uid == null || user == null) res.status(400).send(jsend.error("Bad Request"));
    else userFuncs.registerUser(uid, user, res);
});

// Updates user in firestore
app.put("/user", async (req: Request, res: Response) => {
    var props = req.body;
    if (props == null) res.status(400).send(jsend.error("Bad Request"));
    else userFuncs.updateUser(props, res);
});

// Returns current user
app.get("/user", async (req: Request, res: Response) => {

});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions
    .region('europe-west2') // London
    .https.onRequest(app);