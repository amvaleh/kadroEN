
class PackageCard extends React.Component {

    constructor() {
        super();
        this.state = { 
            show:false,
        }
        this.handleClickPackage=this.handleClickPackage.bind(this);
    }
    handleClickPackage(event)
    {
        this.props.selectPackageCallBack(this.props.data)
    }
    render() {
        
        return (
            <div className={`${this.props.data.order !== this.props.activeHour ? 'package-card hiddenCard ' : this.props.data.is_gold ? 'package-card gold ' : 'package-card '}${this.props.selected?'selected':''}`} >

                <h3 >
                    <img src='img/Verify.svg' alt="" className="popular-icon" style={{ display:this.props.data.is_gold ?  'block' : 'none' }} />

                    {this.props.data.title}</h3>
                <div className="items">
                    <div className="item">
                        {/* <img src="" alt="" className="icon" /> */}
                        <p >میانگین <b>{this.props.data.average_frames} عکس </b></p>
                    </div>
                    <div className="item">
                        {(this.props.data.features.length>0)?
                        <React.Fragment>
                            <img src='img/question.svg'alt="" className="icon" />
                            <p onClick={() => this.props.onModal(this.props.data)} style={{ cursor: 'pointer' }}>اطلاعات بیشتر ... </p>
                        </React.Fragment>:<React.Fragment></React.Fragment>}    
                    </div>
                    
                    <div className="item">
                        {/* <img src="" alt="" className="icon" /> */}
                        <p >{this.props.receiveType=='online-gallery' ?'امکان دانلود فایل ':'تحویل فایل '}<b>{this.props.data.is_full ? 'همه عکس‌ها' : '8 عکس'}</b></p>
                    </div>
                </div>
                <div className="price">
                    <p>{toPersianNumber(new Intl.NumberFormat().format(this.props.data.price))} تومان</p>
                    <div className="button" onClick={this.handleClickPackage}>انتخاب و ادامه</div>
                </div>
            </div>
        )
    }
}
