class Modal extends React.Component {
    constructor() {
        super()
        this.state = {
            isShow: false,
        }
        this.handleClickOutside = this.handleClickOutside.bind(this);
        this.wrapperRef = React.createRef();
    }
    componentDidUpdate(prevProps, prevState) {
        if (this.props.data !== prevProps.data && this.props.data) {
            this.setState({ isShow: true });
        }
    }
    handleClickOutside(event) {
        event.preventDefault();
        if (this.wrapperRef && !this.wrapperRef.current.contains(event.target) && !(event.target.localName=="p" && event.target.innerText=='اطلاعات بیشتر ...')) {
            setTimeout(() => {
                this.props.onClose(null);
            }, 600);
            this.setState({ isShow: false });
        }
            
            
        
    }


    render() {
        return (
                
                <div className={` ${!this.state.isShow ? 'mymodal-container  ' : 'mymodal-container active'}`} ref={this.wrapperRef}>
                   
                    <div className={` ${!this.state.isShow ? 'mymodal ' : 'mymodal active'}`} onClick={e => e.preventDefault()}>
                        < div className="header">
                            <p>{this.props.data ? this.props.data.title : ""}{this.props.data ? ` [ بسته ${this.props.data.order} ساعته ] ` : ''}</p>

                            <span onClick={() => {
                                this.setState({ isShow: false });
                                setTimeout(() => {
                                    this.props.onClose(null);
                                }, 600);
                                
                            }} className='close-mymodal'>&#10006;</span>
                        </div>
                        <div className="text">
                            <ul>
                                {this.props.data ? this.props.data.features.map(i => {
                                    return (<li key={i}>
                                        <div alt="" className="icon" />
                                        <p >{i}</p>
                                    </li>)
                                }) : ''
                                }
                            </ul>
                        </div>
                    </div>
                </div>
        )
    }
}
