Deface::Override.new(:virtual_path => 'gallery/_header',
                     :name => 'add_cart_header_link',
                     :replace => "[data-kadro-hook='cart_header']",
                     :partial => 'overrides/cart_header.html',
                     :namespaced => true,
                     original: '78c118129cf14e5319b589ae123f35267b417dc6')
