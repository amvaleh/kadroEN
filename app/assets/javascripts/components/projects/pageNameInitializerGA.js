const getPagePath = (slug,step)=>{
	switch (step) {
        case 1:
            return '/book/projects/'+slug+'/package'
        case 2:
            return '/book/projects/'+slug+'/location'
        case 3:
            return '/book/projects/'+slug+'/date'
        case 4:
            return '/book/projects/'+slug+'/photographer'
        case 5:
            return '/book/projects/'+slug+'/details'
        case 6:
            return '/book/projects/'+slug+'/invoice'
        case 7:
            return '/book/projects/'+slug+'/delivery'
        default:
            return '/book/projects/'+slug
    }
}
