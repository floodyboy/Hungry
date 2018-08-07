import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/RestaurantCardInfo/Restaurant.dart';

class RestaurantFetcher {
  /// Fetches the restaurants given the latitude and longitude.
  double _lat, _lon;
  Set<String> _selectedCuisines;
  Set<Restaurant> _restaurants;
  String _selectedCuisinesString;
  Map<String, String> categories;
  RestaurantFetcher(this._lat, this. _lon, this._selectedCuisines) {
    categories = {'Acai Bowls': 'acaibowls',
      'Backshop': 'backshop',
      'Bagels': 'bagels',
      'Bakeries': 'bakeries',
      'Beer, Wine & Spirits': 'beer_and_wine',
      'Bento': 'bento',
      'Beverage Store': 'beverage_stores',
      'Boba': 'bubbletea',
      'Breweries': 'breweries',
      'Brewpubs': 'brewpubs',
      'Bubble Tea': 'bubbletea',
      'Butcher': 'butcher',
      'CSA': 'csa',
      'Chimney Cakes': 'chimneycakes',
      'Churros': 'churros',
      'Cideries': 'cideries',
      'Coffee & Tea': 'coffee',
      'Coffee & Tea Supplies': 'coffeeteasupplies',
      'Coffee Roasteries': 'coffeeroasteries',
      'Convenience Stores': 'convenience',
      'Cupcakes': 'cupcakes',
      'Custom Cakes': 'customcakes',
      'Delicatessen': 'delicatessen',
      'Desserts': 'desserts',
      'Distilleries': 'distilleries',
      'Do-It-Yourself Food': 'diyfood',
      'Donairs': 'donairs',
      'Donuts': 'donuts',
      'Empanadas': 'empanadas',
      'Ethical Grocery': 'ethicgrocery',
      'Farmers Market': 'farmersmarket',
      'Fishmonger': 'fishmonger',
      'Food Delivery Services': 'fooddeliveryservices',
      'Food Trucks': 'foodtrucks',
      'Friterie': 'friterie',
      'Gelato': 'gelato',
      'Grocery': 'grocery',
      'Hawker Centre': 'hawkercentre',
      'Honey': 'honey',
      'Ice Cream & Frozen Yogurt': 'icecream',
      'Imported Food': 'importedfood',
      'International Grocery': 'intlgrocery',
      'Internet Cafes': 'internetcafe',
      'Japanese Sweets': 'jpsweets',
      'Taiyaki': 'taiyaki',
      'Juice Bars & Smoothies': 'juicebars',
      'Kiosk': 'kiosk',
      'Kombucha': 'kombucha',
      'Milkshake Bars': 'milkshakebars',
      'Mulled Wine': 'gluhwein',
      'Nasi Lemak': 'nasilemak',
      'Organic Stores': 'organic_stores',
      'Panzerotti': 'panzerotti',
      'Parent Cafes': 'eltern_cafes',
      'Patisserie/Cake Shop': 'cakeshop',
      'Piadina': 'piadina',
      'Poke': 'poke',
      'Pretzels': 'pretzels',
      'Salumerie': 'salumerie',
      'Shaved Ice': 'shavedice',
      'Shaved Snow': 'shavedsnow',
      'Smokehouse': 'smokehouse',
      'Specialty Food': 'gourmet',
      'Candy Stores': 'candy',
      'Cheese Shops': 'cheese',
      'Chocolatiers & Shops': 'chocolate',
      'Dagashi': 'dagashi',
      'Dried Fruit': 'driedfruit',
      'Frozen Food': 'frozenfood',
      'Fruits & Veggies': 'markets',
      'Health Markets': 'healthmarkets',
      'Herbs & Spices': 'herbsandspices',
      'Macarons': 'macarons',
      'Meat Shops': 'meats',
      'Olive Oil': 'oliveoil',
      'Pasta Shops': 'pastashops',
      'Popcorn Shops': 'popcorn',
      'Seafood Markets': 'seafoodmarkets',
      'Tofu Shops': 'tofu',
      'Street Vendors': 'streetvendors',
      'Sugar Shacks': 'sugarshacks',
      'Tea Rooms': 'tea',
      'Torshi': 'torshi',
      'Tortillas': 'tortillas',
      'Water Stores': 'waterstores',
      'Wineries': 'wineries',
      'Wine Tasting Room': 'winetastingroom',
      'Zapiekanka': 'zapiekanka',
      'Afghan': 'afghani',
      'African': 'african',
      'Senegalese': 'senegalese',
      'South African': 'southafrican',
      'American (New)': 'newamerican',
      'Traditional American': 'tradamerican',
      'Andalusian': 'andalusian',
      'Arabian': 'arabian',
      'Arab Pizza': 'arabpizza',
      'Argentine': 'argentine',
      'Armenian': 'armenian',
      'Asian Fusion': 'asianfusion',
      'Asturian': 'asturian',
      'Australian': 'australian',
      'Austrian': 'austrian',
      'Baguettes': 'baguettes',
      'Bangladeshi': 'bangladeshi',
      'Barbeque': 'bbq',
      'Basque': 'basque',
      'Bavarian': 'bavarian',
      'Beer Garden': 'beergarden',
      'Beer Hall': 'beerhall',
      'Beisl': 'beisl',
      'Belgian': 'belgian',
      'Flemish': 'flemish',
      'Bistros': 'bistros',
      'Black Sea': 'blacksea',
      'Brasseries': 'brasseries',
      'Brazilian': 'brazilian',
      'Brazilian Empanadas': 'brazilianempanadas',
      'Central Brazilian': 'centralbrazilian',
      'Northeastern Brazilian': 'northeasternbrazilian',
      'Northern Brazilian': 'northernbrazilian',
      'Rodizios': 'rodizios',
      'Breakfast & Brunch': 'breakfast_brunch',
      'British': 'british',
      'Buffets': 'buffets',
      'Bulgarian': 'bulgarian',
      'Burgers': 'burgers',
      'Burmese': 'burmese',
      'Cafes': 'cafes',
      'Themed Cafes': 'themedcafes',
      'Cafeteria': 'cafeteria',
      'Cajun/Creole': 'cajun',
      'Cambodian': 'cambodian',
      'Canadian': 'New) (newcanadian',
      'Canteen': 'canteen',
      'Caribbean': 'caribbean',
      'Dominican': 'dominican',
      'Haitian': 'haitian',
      'Puerto Rican': 'puertorican',
      'Trinidadian': 'trinidadian',
      'Catalan': 'catalan',
      'Cheesesteaks': 'cheesesteaks',
      'Chicken Shop': 'chickenshop',
      'Chicken Wings': 'chicken_wings',
      'Chilean': 'chilean',
      'Chinese': 'chinese',
      'Cantonese': 'cantonese',
      'Congee': 'congee',
      'Dim Sum': 'dimsum',
      'Fuzhou': 'fuzhou',
      'Hainan': 'hainan',
      'Hakka': 'hakka',
      'Henghwa': 'henghwa',
      'Hokkien': 'hokkien',
      'Hunan': 'hunan',
      'Pekinese': 'pekinese',
      'Shanghainese': 'shanghainese',
      'Szechuan': 'szechuan',
      'Teochew': 'teochew',
      'Comfort Food': 'comfortfood',
      'Corsican': 'corsican',
      'Creperies': 'creperies',
      'Cuban': 'cuban',
      'Curry Sausage': 'currysausage',
      'Cypriot': 'cypriot',
      'Czech': 'czech',
      'Czech/Slovakian': 'czechslovakian',
      'Danish': 'danish',
      'Delis': 'delis',
      'Diners': 'diners',
      'Dinner Theater': 'dinnertheater',
      'Dumplings': 'dumplings',
      'Eastern European': 'eastern_european',
      'Ethiopian': 'ethiopian',
      'Fast Food': 'hotdogs',
      'Filipino': 'filipino',
      'Fischbroetchen': 'fischbroetchen',
      'Fish & Chips': 'fishnchips',
      'Flatbread': 'flatbread',
      'Fondue': 'fondue',
      'Food Court': 'food_court',
      'Food Stands': 'foodstands',
      'Freiduria': 'freiduria',
      'French': 'french',
      'Alsatian': 'alsatian',
      'Auvergnat': 'auvergnat',
      'Berrichon': 'berrichon',
      'Bourguignon': 'bourguignon',
      'Mauritius': 'mauritius',
      'Nicoise': 'nicois',
      'Provencal': 'provencal',
      'Reunion': 'reunion',
      'French Southwest': 'sud_ouest',
      'Galician': 'galician',
      'Game Meat': 'gamemeat',
      'Gastropubs': 'gastropubs',
      'Georgian': 'georgian',
      'German': 'german',
      'Baden': 'baden',
      'Eastern German': 'easterngerman',
      'Franconian': 'franconian',
      'Hessian': 'hessian',
      'Northern German': 'northerngerman',
      'Palatine': 'palatine',
      'Rhinelandian': 'rhinelandian',
      'Giblets': 'giblets',
      'Gluten-Free': 'gluten_free',
      'Greek': 'greek',
      'Guamanian': 'guamanian',
      'Halal': 'halal',
      'Hawaiian': 'hawaiian',
      'Heuriger': 'heuriger',
      'Himalayan/Nepalese': 'himalayan',
      'Honduran': 'honduran',
      'Hong Kong Style Cafe': 'hkcafe',
      'Hot Dogs': 'hotdog',
      'Hot Pot': 'hotpot',
      'Hungarian': 'hungarian',
      'Iberian': 'iberian',
      'Indian': 'indpak',
      'Indonesian': 'indonesian',
      'International': 'international',
      'Irish': 'irish',
      'Island Pub': 'island_pub',
      'Israeli': 'israeli',
      'Italian': 'italian',
      'Abruzzese': 'abruzzese',
      'Altoatesine': 'altoatesine',
      'Apulian': 'apulian',
      'Calabrian': 'calabrian',
      'Cucina campana': 'cucinacampana',
      'Emilian': 'emilian',
      'Friulan': 'friulan',
      'Ligurian': 'ligurian',
      'Lumbard': 'lumbard',
      'Napoletana': 'napoletana',
      'Piemonte': 'piemonte',
      'Roman': 'roman',
      'Sardinian': 'sardinian',
      'Sicilian': 'sicilian',
      'Tuscan': 'tuscan',
      'Venetian': 'venetian',
      'Japanese': 'japanese',
      'Blowfish': 'blowfish',
      'Conveyor Belt Sushi': 'conveyorsushi',
      'Donburi': 'donburi',
      'Gyudon': 'gyudon',
      'Oyakodon': 'oyakodon',
      'Hand Rolls': 'handrolls',
      'Horumon': 'horumon',
      'Izakaya': 'izakaya',
      'Japanese Curry': 'japacurry',
      'Kaiseki': 'kaiseki',
      'Kushikatsu': 'kushikatsu',
      'Oden': 'oden',
      'Okinawan': 'okinawan',
      'Okonomiyaki': 'okonomiyaki',
      'Onigiri': 'onigiri',
      'Ramen': 'ramen',
      'Robatayaki': 'robatayaki',
      'Soba': 'soba',
      'Sukiyaki': 'sukiyaki',
      'Takoyaki': 'takoyaki',
      'Tempura': 'tempura',
      'Teppanyaki': 'teppanyaki',
      'Tonkatsu': 'tonkatsu',
      'Udon': 'udon',
      'Unagi': 'unagi',
      'Western Style Japanese Food': 'westernjapanese',
      'Yakiniku': 'yakiniku',
      'Yakitori': 'yakitori',
      'Jewish': 'jewish',
      'Kebab': 'kebab',
      'Kopitiam': 'kopitiam',
      'Korean': 'korean',
      'Kosher': 'kosher',
      'Kurdish': 'kurdish',
      'Laos': 'laos',
      'Laotian': 'laotian',
      'Latin American': 'latin',
      'Colombian': 'colombian',
      'Salvadoran': 'salvadoran',
      'Venezuelan': 'venezuelan',
      'Live/Raw Food': 'raw_food',
      'Lyonnais': 'lyonnais',
      'Malaysian': 'malaysian',
      'Mamak': 'mamak',
      'Nyonya': 'nyonya',
      'Meatballs': 'meatballs',
      'Mediterranean': 'mediterranean',
      'Falafel': 'falafel',
      'Mexican': 'mexican',
      'Eastern Mexican': 'easternmexican',
      'Jaliscan': 'jaliscan',
      'Northern Mexican': 'northernmexican',
      'Oaxacan': 'oaxacan',
      'Pueblan': 'pueblan',
      'Tacos': 'tacos',
      'Tamales': 'tamales',
      'Yucatan': 'yucatan',
      'Middle Eastern': 'mideastern',
      'Egyptian': 'egyptian',
      'Lebanese': 'lebanese',
      'Milk Bars': 'milkbars',
      'Modern Australian': 'modern_australian',
      'Modern European': 'modern_european',
      'Mongolian': 'mongolian',
      'Moroccan': 'moroccan',
      'New Mexican Cuisine': 'newmexican',
      'New Zealand': 'newzealand',
      'Nicaraguan': 'nicaraguan',
      'Night Food': 'nightfood',
      'Nikkei': 'nikkei',
      'Noodles': 'noodles',
      'Norcinerie': 'norcinerie',
      'Open Sandwiches': 'opensandwiches',
      'Oriental': 'oriental',
      'PF/Comercial': 'pfcomercial',
      'Pakistani': 'pakistani',
      'Pan Asian': 'panasian',
      'Parma': 'parma',
      'Persian/Iranian': 'persian',
      'Peruvian': 'peruvian',
      'Pita': 'pita',
      'Pizza': 'pizza',
      'Polish': 'polish',
      'Pierogis': 'pierogis',
      'Polynesian': 'polynesian',
      'Pop-Up Restaurants': 'popuprestaurants',
      'Portuguese': 'portuguese',
      'Alentejo': 'alentejo',
      'Algarve': 'algarve',
      'Azores': 'azores',
      'Beira': 'beira',
      'Fado Houses': 'fado_houses',
      'Madeira': 'madeira',
      'Minho': 'minho',
      'Ribatejo': 'ribatejo',
      'Tras-os-Montes': 'tras_os_montes',
      'Potatoes': 'potatoes',
      'Poutineries': 'poutineries',
      'Pub Food': 'pubfood',
      'Rice': 'riceshop',
      'Romanian': 'romanian',
      'Rotisserie Chicken': 'rotisserie_chicken',
      'Russian': 'russian',
      'Salad': 'salad',
      'Sandwiches': 'sandwiches',
      'Scandinavian': 'scandinavian',
      'Schnitzel': 'schnitzel',
      'Scottish': 'scottish',
      'Seafood': 'seafood',
      'Serbo Croatian': 'serbocroatian',
      'Signature Cuisine': 'signature_cuisine',
      'Singaporean': 'singaporean',
      'Slovakian': 'slovakian',
      'Soul Food': 'soulfood',
      'Soup': 'soup',
      'Southern': 'southern',
      'Spanish': 'spanish',
      'Arroceria / Paella': 'arroceria_paella',
      'Sri Lankan': 'srilankan',
      'Steakhouses': 'steak',
      'Supper Clubs': 'supperclubs',
      'Sushi Bars': 'sushi',
      'Swabian': 'swabian',
      'Swedish': 'swedish',
      'Swiss Food': 'swissfood',
      'Syrian': 'syrian',
      'Tabernas': 'tabernas',
      'Taiwanese': 'taiwanese',
      'Tapas Bars': 'tapas',
      'Tapas/Small Plates': 'tapasmallplates',
      'Tavola Calda': 'tavolacalda',
      'Tex-Mex': 'tex-mex',
      'Thai': 'thai',
      'Traditional Norwegian': 'norwegian',
      'Traditional Swedish': 'traditional_swedish',
      'Trattorie': 'trattorie',
      'Turkish': 'turkish',
      'Chee Kufta': 'cheekufta',
      'Gozleme': 'gozleme',
      'Homemade Food': 'homemadefood',
      'Lahmacun': 'lahmacun',
      'Ottoman Cuisine': 'ottomancuisine',
      'Turkish Ravioli': 'turkishravioli',
      'Ukrainian': 'ukrainian',
      'Uzbek': 'uzbek',
      'Vegan': 'vegan',
      'Vegetarian': 'vegetarian',
      'Venison': 'venison',
      'Vietnamese': 'vietnamese',
      'Waffles': 'waffles',
      'Wok': 'wok',
      'Wraps': 'wraps',
      'Yugoslav': 'yugoslav',};
    _selectedCuisinesString = buildCuisines();
  }


  Set<Restaurant> get restaurants => _restaurants;

  Future<Set<Restaurant>> fetchRestaurants() async {
    /// Gets each restaurant and places it into the Future<Set<Restaurant>>
    _restaurants = new Set<Restaurant>();
    var url;
    if (_selectedCuisines.isNotEmpty) {
      url =
          "https://api.yelp.com/v3/businesses/search?term=restaurant&categories=${_selectedCuisinesString}&latitude=${_lat}&longitude=${_lon}";
    } else {
      url =
      "https://api.yelp.com/v3/businesses/search?term=restaurant&latitude=${_lat}&longitude=${_lon}";
    }
      print(url);
    var response = await http.get(
        url,
        headers: {HttpHeaders.AUTHORIZATION: "Bearer c8eYj3EGPOlR3xcHsDrcdvSI17QkI4NXtUPLuux006pN-MLKggrzpFyG42T2Y40geFAJn8shKLtYEg5GcRmlO6nAHhZ-rLpV1UqQv87T53-NNDIerPM2bOPSiz9FW3Yx"},
        );
    print(response.statusCode);

    Map<String, dynamic> result = json.decode(response.body.toString());
    if (result['total'] == 0) return null;
    result['businesses']
        .forEach((rest) => _restaurants.add(new Restaurant.fromJson(rest)));
    if (_restaurants.isNotEmpty) {
      _restaurants.forEach((restaurant) => print(restaurant.name));
    }
    return _restaurants;
  }

  String buildCuisines() {
    if (_selectedCuisines.isEmpty) {
      return '';
    }
    StringBuffer cuisines = StringBuffer();
    for (String cuisine in _selectedCuisines) {
      if (cuisine != null && categories[cuisine] != null) {
        cuisines.write(categories[cuisine] + ',');
      }
    }
    return cuisines.toString().substring(0, cuisines.toString().length - 1);
  }
}
