/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import * as jsend from "../jsend";
import * as certRepo from "./certifications_repository";
import * as parser from "./certification_summary_parser";

// Sends response with certifications from firestore by platform as json
export async function getFromFirestoreByPlatform(
    platform: string,
    res: functions.Response) {
    try {
        const items = await certRepo.getFromFirestoreByPlatformAsList(platform);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetCertifs(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

// Sends response with certifications from firestore by category & subcategory as json
export async function getFromFirestoreByCategory(
    category: string,
    subcategory: string,
    res: functions.Response) {
    try {
        const items = await certRepo.getFromFirestoreByCategoryAsList(category, subcategory);
        res.setHeader('Content-Type', 'application/json');
        res.statusCode = 200;
        res.send(jsend.successGetCertifs(items));
    } catch (e) {
        logger.log(e)
        res.statusCode = 500;
        res.send(jsend.error());
    }
}

// Updates a certification in firestore
export async function updateInFirestore(
    title: string,
    id: string,
    properties: any,
    res: functions.Response
) {
    try {
        logger.log(title);
        logger.log(id);
        const desc = properties["description"];
        logger.log(desc);
        const rating = properties["rating"];
        logger.log(rating);
        if (title != null && desc != null) {
            await certRepo.updateDescription(title, desc);
        }
        if (id != null && rating != null) {
            await certRepo.updateRating(id, rating);
        }
        res.statusCode = 200;
        res.send(jsend.success("Certification updated successfully"));
    } catch (e) {
        res.statusCode = 404;
        res.send(jsend.error("Certification not found", 404));
    }
}

// Executes PUT request to add description to a certification
// Will be used only by us. 
export async function putDescription(
    url: string,
    title: string,
    res: functions.Response) {
    const fullUrl = url + "?title=" + title;
    const description = parser.getDescription(title);
    await axios.default.put(fullUrl,
        { description: description })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(jsend.success(resp.statusText));
        }).catch((e) => {
            console.log(e);
            res.statusCode = 500;
            res.send(jsend.error());
        });
}



