Feature: MyAnimeListFinder
  Finding anime should be super-easy!
  Everyone should be able to find his/her
  most loveable series to watch.
  
  Scenario: Find me some nice series like Slayers
    When I run `nyanime find myanimelist slayers`
    Then the output should contain "TODO: find"
    
  Scenario: Give me full information on Slayers Excellent
    When I run `nyanime get myanimelist XXX`
    Then the output should contain "TODO: get"
  
  Scenario: Give me full information on Slayers - The Motion Picture
    When I run `nyanime get myanimelist YYY`
    Then the output should contain "TODO: get"
    
  Scenario: Find me something new like Shingeki no Kyojin
    When I run `nyanime find myanimelist shingeki no kyojin`
    Then the output should contain "TODO: find"
  
  Scenario: Give me full information on Shingeki no Kyojin
    When I run `nyanime get myanimelist ZZZ`
    Then the output should contain "TODO: get"
