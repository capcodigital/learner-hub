import descriptions from "./certification_summary.json";

export function getDescription(title: string): string | null {
    const category = descriptions.category;
    var des = null;
    des = findCloud(title, category[0]);
    if (des != null) return des;
    des = findSecurity(title, category[1]);
    if (des != null) return des;
    des = findBlockchain(title, category[2]);
    if (des != null) return des;
    des = findMobile(title, category[3]);
    if (des != null) return des;
    return null;
}

function findCloud(title: string, item: any) {
    const cloud = item["cloud"];
    const platforms = cloud!!.platform;
    for (var i = 0; i < platforms.length; i++) {
        const platform = platforms[i];
        const aws = platform['aws'];
        const gcp = platform['gcp'];
        const hashicorp = platform['hashicorp'];
        const azure = platform['azure'];
        const cncf = platform['cncf'];
        const isc2 = platform['isc2'];
        if (aws != null) {
            var des = findDescription(title, aws);
            if (des != null) return des;
        }
        else if (gcp != null) {
            const des = findDescription(title, gcp);
            if (des != null) return des;
        }
        else if (hashicorp != null) {
            const des = findDescription(title, hashicorp);
            if (des != null) return des;
        }
        else if (azure != null) {
            const des = findDescription(title, azure);
            if (des != null) return des;
        }
        else if (cncf != null) {
            const des = findDescription(title, cncf);
            if (des != null) return des;
        }
        else if (isc2 != null) {
            const des = findDescription(title, isc2);
            if (des != null) return des;
        }
    }
    return null;
}

function findSecurity(title: string, item: any) {
    const security = item["security"];
    const platforms = security!!.platform;
    for (var i = 0; i < platforms.length; i++) {
        const platform = platforms[i];
        const udemy = platform.udemy;
        const api_academy = platform["api academy"];
        if (udemy != null) {
            var des = findDescription(title, udemy);
            if (des != null) return des;
        }
        else if (api_academy != null) {
            const des = findDescription(title, api_academy);
            if (des != null) return des;
        }
    }
    return null;
}

function findBlockchain(title: string, item: any) {
    const blockchain = item["blockchain"];
    const platforms = blockchain!!.platform;
    for (var i = 0; i < platforms.length; i++) {
        const platform = platforms[i];
        const corda = platform.udemy;
        if (corda != null) {
            var des = findDescription(title, corda);
            if (des != null) return des;
        }
    }
    return null;
}

function findMobile(title: string, item: any) {
    const mobile = item["mobile"];
    const platforms = mobile!!.platform;
    for (var i = 0; i < platforms.length; i++) {
        const platform = platforms[i];
        const android = platform.android;
        if (android != null) {
            var des = findDescription(title, android);
            if (des != null) return des;
        }
    }
    return null;
}

function findDescription(
    title: string,
    items: Certificate[]
): string | null {
    const result = items.filter(item => item.title.toLowerCase() == title.toLowerCase());
    if (result.length > 1) throw Error("More than 1 Certificates with same title!");
    return result.length == 1 ? result[0].description : null;
}