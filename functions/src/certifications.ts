import data from '../test/catalog.json';

type Certification = {
    id: number;
    name: String;
    category: String;
    subcategory: String;
    url:String;
};

export const  getUrl = (id: number) : String => {
    const certFilter: Certification[] = data.filter((c: Certification) => c.id == id);
    console.log(certFilter);
    var url = (certFilter.length > 0) ? ( certFilter[0].url) :("") ;
    return url;
}