import { logger } from "firebase-functions/v1";
import { JSDOM } from "jsdom";
import { CatalogEntry } from "../catalog_entry";
import { filter } from "../../txtutil";

export function extractUdemySecurityCourses(html: string, certData: CatalogEntry): Array<Certification> {
    const parser = new JSDOM(html);
    const tables = parser.window.document.querySelectorAll("table");

    if (tables.length != 1) {
        throw "Invalid format. Please review the HTML matches the expected format";
    }

    const peopleTable = tables[0];
    const rows = peopleTable.querySelectorAll("tr");
    // First row is the header, the rest is the content
    const [, ...items] = rows;

    let entries = Array<Certification>();
    items.forEach(row => {
        // The name is inside a <a> inside a <th> tag. Since that <th> is not right to be there (is not a header)
        // I think it's better just to use the link <a> added by confluence when an user is mentioned with @user
        const name = row.querySelector("a")?.textContent as string;
        const course = row.querySelector("td:nth-child(3)")?.textContent as string;
        const date = row.querySelector("td:nth-child(4)")?.textContent as string;
        entries.push({
            'username': filter(name?.trim()),
            'platform': "",
            'title': filter(course?.trim()),
            'category': filter(certData?.category),
            'subcategory': filter(certData?.subcategory),
            'date': filter(date?.trim()),
            'description': "",
            'rating': 0
        });
    });
    logger.log(`Extracted ${entries.length}/${items.length} Udemy Security courses`);
    return entries;
}