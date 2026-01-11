module Adapters

export EurostatAdapter
export GTAPAdapter
export load_iobundle

struct EurostatAdapter
    source::String
end

struct GTAPAdapter
    source::String
end

"""
Stub adapter: normalize external Eurostat data into an IOBundle.
"""
function load_iobundle(::EurostatAdapter)
    error("Eurostat adapter not implemented yet. Map your source tables into an IOBundle.")
end

"""
Stub adapter: normalize external GTAP data into an IOBundle.
"""
function load_iobundle(::GTAPAdapter)
    error("GTAP adapter not implemented yet. Map your source tables into an IOBundle.")
end

end # module
