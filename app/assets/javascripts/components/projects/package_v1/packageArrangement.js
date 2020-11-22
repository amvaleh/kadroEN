
function packageArrangement(packages,recommendationHour) {
	let privateGalleryOrderedPackages=[];
    let memoryPlusOrderedPackages=[];
    let galleryHours=[];
    let memoryHours=[];
    let memoryEnglishHours=[];
    let galleryEnglishHours=[];
    let galleryTicks=[];
    let memoryTicks=[];
    let hoursMemoryPackagesMap=[];
    let hoursGalleryPackagesMap=[];
    let thisHourGalleryPackages=[];
    let thisHourMemoryPackages=[];

	packages.sort((a, b) => a['order'] > b['order'] )
    .map((item,i) =>{

        if(item.is_full && checkHourPackagesHasOrder(item['order'],hoursMemoryPackagesMap)){
            pushHourPackagesByOrder(item['order'],item,hoursMemoryPackagesMap);
        }
        else if(item.is_full && !checkHourPackagesHasOrder(item['order'],hoursMemoryPackagesMap))
        {
                let newMemoryPackages=[];
                newMemoryPackages.push(item);
                let packageMemoryMap={'order':item['order'],'packages':newMemoryPackages}
                hoursMemoryPackagesMap.push(packageMemoryMap);

        }
        if(checkHourPackagesHasOrder(item['order'],hoursGalleryPackagesMap)){
            pushHourPackagesByOrder(item['order'],item,hoursGalleryPackagesMap);
        }
        else if(!checkHourPackagesHasOrder(item['order'],hoursGalleryPackagesMap))
        {
            let newGalleryPackages=[];
            newGalleryPackages.push(item);
            let packageGalleryMap={'order':item['order'],'packages':newGalleryPackages}
            hoursGalleryPackagesMap.push(packageGalleryMap);
        }
	});

    hoursMemoryPackagesMap.sort(function(a, b) {
        return a.order - b.order;
    });
    hoursGalleryPackagesMap.sort(function(a, b) {
        return a.order - b.order;
    });
    for (let i = 0; i < hoursGalleryPackagesMap.length; i++) {
        galleryEnglishHours.push(hoursGalleryPackagesMap[i].order);
        galleryHours.push(hourMappingToPersian(hoursGalleryPackagesMap[i].order));
        galleryTicks.push(i);

        thisHourGalleryPackages=[];
        for (let j = 0; j < hoursGalleryPackagesMap[i].packages.length; j++) {

            if(hoursGalleryPackagesMap[i].packages[j].is_full)
                hoursGalleryPackagesMap[i].packages[j]['description1']='دانلود همه عکس ها';

            hoursGalleryPackagesMap[i].packages[j]['description']="دانلود "+
                (toPersianNumber(hoursGalleryPackagesMap[i].packages[j]['digitals']))+" فایل از بین همه عکس ها (هر اضافی "+
                (toPersianNumber(hoursGalleryPackagesMap[i].packages[j]['extra_price']))+
                " تومان)";
            thisHourGalleryPackages.push(hoursGalleryPackagesMap[i].packages[j]);
        }
        privateGalleryOrderedPackages.push(thisHourGalleryPackages);
    }
    for (let i = 0; i < hoursMemoryPackagesMap.length; i++) {
        memoryEnglishHours.push(hoursMemoryPackagesMap[i].order);
        memoryHours.push(hourMappingToPersian(hoursMemoryPackagesMap[i].order));
        memoryTicks.push(i);

        thisHourMemoryPackages=[];
        for (let j = 0; j < hoursMemoryPackagesMap[i].packages.length; j++) {

            hoursMemoryPackagesMap[i].packages[j]['description1']='دانلود همه عکس ها';
            thisHourMemoryPackages.push(hoursMemoryPackagesMap[i].packages[j]);
        }
        memoryPlusOrderedPackages.push(thisHourMemoryPackages);
    }

    return  {
    	galleryEnglishHours: galleryEnglishHours,
		galleryHours : galleryHours,
		galleryTicks:galleryTicks,
		memoryEnglishHours:memoryEnglishHours,
		memoryHours:memoryHours,
		memoryTicks:memoryTicks,
		privateGalleryOrderedPackages:privateGalleryOrderedPackages,
		memoryPlusOrderedPackages:memoryPlusOrderedPackages
    }

}
function checkHourPackagesHasOrder(order,hoursPackagesMap) {
	let founded=false;
    for (var i = hoursPackagesMap.length - 1; i >= 0; i--) {

        if(hoursPackagesMap[i].order==order){
            founded=true;
        }

    }
    return founded;
}
function pushHourPackagesByOrder(order,thisPackage,hoursPackagesMap){
	for (var i =0 ; i < hoursPackagesMap.length; i++) {

        if(hoursPackagesMap[i].order==order){

            let newPackages=[];
            newPackages=hoursPackagesMap[i].packages;
            newPackages.push(thisPackage);
            newPackages.sort(function(a, b) {
                if(b.is_full)
                    return 1;
                else
                    return -1;
            });
            hoursPackagesMap[i].packages=newPackages;

        }

    }
}
function hourMappingToPersian(order){
	 //convert English Float Numbers to Persian Number Words
    let persianLetters = "صفر یک دو سه چهار پنج شش هفت هشت نه";
    let persianMap = persianLetters.split(" ");
    if(Number(order) === order && order % 1 === 0)
    {
        return(order.toString().replace(/\d/g, function (m) {
                                            return persianMap[parseInt(m)];
                                        })+" ساعت ");
    }
    else{
        if(order<1){
            return("نیم ساعت");
        }
        else{
            let newOrder=Math.floor(order);
            return(newOrder.toString().replace(/\d/g, function (m) {
                                                return persianMap[parseInt(m)];
                                            })+" ساعت و نیم");
        }
    }
}