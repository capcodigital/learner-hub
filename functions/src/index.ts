import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import * as certSummaryFuncs from "./certification_summaries/certification_summary_funcs";
import * as userFuncs from "./users/user_funcs";
import * as userCertFuncs from "./user_certifications/user_certifications_funcs";
import * as todoFuncs from "./todos/todo_funcs";
import * as jsend from "./jsend";
import cors from "cors";
import helmet from "helmet";

// Initialize Firebase app
admin.initializeApp();

// Initialize and configure Express server
var cookieParser = require('cookie-parser')
var csrf = require('csurf')

// setup route middlewares
var csrfProtection = csrf({ cookie: true })

export const app = express();
app.use(cookieParser())
app.use(
  cors({
    // Add a list of allowed origins.
    // If you have more origins you would like to add, you can add them to the array below.
    origin: ["http://localhost:58668"],
  })
);
app.use(helmet());
app.use(validateFirebaseIdToken);

// CERTIFICATION SUMMARY ENDPOINTS

// Returns all certification summaries from firestore as json
app.get("/certificationSummary", csrfProtection, async (req: Request, res: Response) => {
  certSummaryFuncs.getAllCertificationSummaries(res); 
});

// Returns a certifications by id
app.get("/certificationSummary/:id", csrfProtection, async (req: Request, res: Response) => {
  const id = req.params.id as string;
  if (id == null) {
    res.statusCode = 400;
    res.send(jsend.error("Bad Request"));
  } else {
    certSummaryFuncs.getCertificationSummary(id, res);
  }
});

// Adds a certification summary to firestore
app.post("/certificationSummary", csrfProtection, async (req: Request, res: Response) => {
  const summary = req.body as any;
  certSummaryFuncs.addCertificationSummary(summary, res);
});

// USER ENDPOINTS

// Adds user in firestore
app.post("/user", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const request = req.body;
  if (uid != null && request != null) userFuncs.registerUser(uid, request, res);
  else if (uid == null) res.status(401).send(jsend.error("Unauthorized"));
  else res.status(400).send(jsend.error("Bad Request"));
});

// Updates user in firestore
app.put("/user", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  var user = req.body;
  if (user == null) res.status(400).send(jsend.error("Bad Request"));
  else userFuncs.updateUser(uid, user, res);
});

// Returns current user
app.get("/user", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  if (uid != null) userFuncs.getUser(uid, res);
  else res.status(500).send(jsend.error);
});

// USER CERTIFICATION ENDPOINTS

// Returns the certifications of user with passed id.
// If no id passed, then user is current user.
app.get("/certifications/:userId", csrfProtection, async (req: Request, res: Response) => {
  var uid = req.params.userId;
  if (uid == null) uid = req.user?.uid as string;
  if (uid != null) userCertFuncs.getUserCertifications(uid, res);
  else res.status(400).send(jsend.error("Bad Request"));
});

// Creates a Certification to firestore for current user
app.post("/certifications", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const cert = req.body as any;
  if (uid == null) res.status(401).send(jsend.error("Unauthorized"));
  else if (cert == null) res.status(400).send(jsend.error("Bad Request"));
  else userCertFuncs.addUserCertification(uid, cert, res);
});

// Updates the certification of given id in firestore
app.put("/certifications/:id", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const certId = req.params.id;
  const cert = req.body as any;
  if (certId == null || cert == null)
    res.status(400).send(jsend.error("Bad Request"));
  else userCertFuncs.updateUserCertification(uid, certId, cert, res);
});

// Deletes the certification of given id in firestore
app.delete("/certifications/:id", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const certId = req.params.id;
  if (certId == null) res.status(400).send(jsend.error("Bad Request"));
  else userCertFuncs.deleteUserCertification(uid, certId, res);
});

// TODO ENDPOINTS

// Returns the TODOs of user with passed id.
// If no id passed, then user is current user.
app.get("/todos", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  todoFuncs.getTODOs(uid, res);
});

// Creates a TODO to firestore for current user
app.post("/todos", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const body = req.body as any;
  if (body == null) res.status(400).send(jsend.error("Bad Request"));
  else {
    const todo: TODO = {
      userId: uid,
      title: body["title"],
      content: body["content"],
      isCompleted: body["isCompleted"],
    };
    todoFuncs.addTODO(todo, res);
  }
});

// Updates the TODO of given id in firestore
app.put("/todos/:id", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const todoId = req.params.id;
  const body = req.body as any;
  if (todoId == null || body == null)
    res.status(400).send(jsend.error("Bad Request"));
  else {
    const todo: TODO = {
      userId: uid,
      title: body["title"],
      content: body["content"],
      isCompleted: body["isCompleted"],
    };
    todoFuncs.updateTODO(todoId, todo, res);
  }
});

// Deletes the TODO of given id in firestore
app.delete("/todos/:id", csrfProtection, async (req: Request, res: Response) => {
  const uid = req.user?.uid as string;
  const todoId = req.params.id;
  if (todoId == null) res.status(400).send(jsend.error("Bad Request"));
  else todoFuncs.deleteTODO(uid, todoId, res);
});

// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions
  .region("europe-west2") // London
  .https.onRequest(app);
