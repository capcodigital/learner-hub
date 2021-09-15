/* eslint-disable require-jsdoc */
import * as functions from "firebase-functions";
import * as axios from 'axios';
import { logger } from "firebase-functions";
import * as jsend from "../jsend";
import * as certRepo from "./certifications_repository";
import descriptions from "./descriptions.json";

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
        //logger.log(title);
        //logger.log(id);
        const desc = properties["description"];
        //logger.log(desc);
        const rating = properties["rating"];
        //logger.log(rating);
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
    certTitle: string,
    res: functions.Response) {
    const fullUrl = url + "?title=" + certTitle;
    const des = findDescription(certTitle);
    logger.log(des);
    await axios.default.put(fullUrl,
        { description: des })
        .then(function (resp) {
            res.statusCode = 200;
            res.send(jsend.success(resp.statusText));
        }).catch((e) => {
            console.log(e);
            res.statusCode = 500;
            res.send(jsend.error());
        });
}

function findDescription(title: string): string | null {
    const category = descriptions.category;

    const cloud = category[0]["cloud"];
    const cloudPlatforms = cloud!!.platform;
    for (var i = 0; i < cloudPlatforms.length; i++) {
        const platform = cloudPlatforms[i];

        const aws = platform['aws'];
        const gcp = platform['gcp'];
        const hashicorp = platform['hashicorp'];
        const azure = platform['azure'];
        const cncf = platform['cncf'];
        const isc2 = platform['isc2'];

        if (aws != null) {
            var des = findInList(title, aws);
            if (des != null) return des;
        }
        else if (gcp != null) {
            const des = findInList(title, gcp);
            if (des != null) return des;
        }
        else if (hashicorp != null) {
            const des = findInList(title, hashicorp);
            if (des != null) return des;
        }
        else if (azure != null) {
            const des = findInList(title, azure);
            if (des != null) return des;
        }
        else if (cncf != null) {
            const des = findInList(title, cncf);
            if (des != null) return des;
        }
        else if (isc2 != null) {
            const des = findInList(title, isc2);
            if (des != null) return des;
        }
    }

    const security = category[1]["security"];
    const securityPlatforms = security!!.platform;
    for (var i = 0; i < securityPlatforms.length; i++) {
        const platform = securityPlatforms[i];

        const udemy = platform.udemy;
        const api_academy = platform["api academy"];

        if (udemy != null) {
            var des = findInList(title, udemy);
            if (des != null) return des;
        }
        else if (api_academy != null) {
            const des = findInList(title, api_academy);
            if (des != null) return des;
        }
    }

    return null;
}

function findInList(
    title: string,
    items: Certificate[]
): string | null {
    const result = items.filter(item => item.title.toLowerCase() == title.toLowerCase());
    if (result.length > 1) throw Error("More than 1 Certificates with same title!");
    return result.length == 1 ? result[0].description : null;
}

