@(
    # -- Pascal
    @{ Phrase = 'OneTwoThree'; Expect = @( 'One', 'Two', 'Three') }
    @{ Phrase = 'TheHTTPServer'; Expect = @('The', 'HTTP', 'Server') }
    #TODO: Should the number be separate?
    @{ Phrase = 'Usb3Port'; Expect = @('Usb', '3', 'Port') }
    # -- Camel
    @{ Phrase = 'oneTwoThree'; Expect = @( 'one', 'Two', 'Three') }
    @{ Phrase = 'theHTTPServer'; Expect = @('the', 'HTTP', 'Server') }
    @{ Phrase = 'usb3Port'; Expect = @('usb', '3', 'Port') }
    # -- Snake
    @{ Phrase = 'one_two_three'; Expect = @( 'one', 'two', 'three') }
    @{ Phrase = 'the_http_server'; Expect = @('the', 'http', 'server') }
    @{ Phrase = 'usb3_port'; Expect = @('usb3', 'port') }

)
