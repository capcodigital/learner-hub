import { DecodedIdToken } from "firebase-admin/auth";

declare global {
  // Extend the Request type from Express Framework to add the user
  namespace Express {
    export interface Request {
      user?: DecodedIdToken;
    }
  }
}
