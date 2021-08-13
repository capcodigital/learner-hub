 import  data from './catalog.json';

type CatalogUrl = {
    id: number;
    name: String;
    category: String;
    subcategory: String;
    url:String;
};


export const  getUrl = (id: number) : String => {
    const catalogFilter: CatalogUrl[] = data.filter((c: CatalogUrl) => c.id == id);
    console.log(catalogFilter);
    var url = (catalogFilter.length > 0) ? ( catalogFilter[0].url) :("") ;
    return url;
}
