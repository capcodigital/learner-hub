import * as functions from "firebase-functions";
import express, { Request, Response } from "express";
import { validateFirebaseIdToken } from "./auth-middleware";
import { getUrl } from "./url-provider";

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

app.get("/catalog/:id", (req: Request, res: Response) => {
      const id = <any>req.params.id;
      const url = getUrl(id);
     res.send(url);
});


// This HTTPS endpoint can only be accessed by your Firebase Users.
// Requests need to be authorized by providing an `Authorization` HTTP header
// with value `Bearer <Firebase ID Token>`.
exports.app = functions.https.onRequest(app);