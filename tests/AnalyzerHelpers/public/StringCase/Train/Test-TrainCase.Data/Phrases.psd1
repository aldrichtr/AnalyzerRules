@(
    @{Phrase = 'oneTwoThree';   Expect = $false}
    @{Phrase = 'one_two_three'; Expect = $false}
    @{Phrase = 'one-two-three'; Expect = $false}
    @{Phrase = 'ONE-TWO-THREE'; Expect = $false}
    @{Phrase = 'One-Two-three'; Expect = $true}
)