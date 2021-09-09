/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import * as jsend from "../jsend";
import * as certRepo from "./certifications_repository";

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
        res.send(jsend.error("Error occurred"));
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
        res.send(jsend.error("Error occurred"));
    }
}

// Updates the description of certifications of a given title in firestore
// and returns a response
export async function describe(
    title: string,
    desc: string,
    res: functions.Response
) {
    try {
        certRepo.updateDescription(title, desc);
        res.statusCode = 200;
        res.send(jsend.success());
    } catch (e) {
        res.statusCode = 500;
        res.send(jsend.error("Error adding description"));
    }
}

// Updates the rating of certifications of a given id in firestore
// and returns a response
export async function rate(
    certId: string,
    rating: number,
    res: functions.Response
) {
    try {
        certRepo.updateRating(certId, rating);
        res.statusCode = 200;
        res.send(jsend.success());
    } catch (e) {
        res.statusCode = 500;
        res.send(jsend.error("Error adding rating"));
    }
}

// Executes PUT request to add description to a certification
export async function putDescription(
    url: string,
    certTitle: string,
    description: string,
    res: functions.Response) {
    const fullUrl = url + "?title=" + certTitle;
    await axios.default.put(fullUrl,
        { desc: description })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(resp.data);
        }).catch((e) => {
            console.log(e);
            res.statusCode = 500;
            res.send(jsend.error("Error adding description"));
        });
}

// Executes PUT request to add rating to a certification
export async function putRating(
    url: string,
    certId: string,
    rating: number,
    res: functions.Response) {
    const fullUrl = url + "?id=" + certId;
    await axios.default.put(fullUrl,
        { rating: rating })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(jsend.success());
        }).catch((e) => {
            logger.log(e);
            res.statusCode = 500;
            res.send(jsend.error("Error adding rating"));
        });
}