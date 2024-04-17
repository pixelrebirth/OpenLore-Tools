. "$PSScriptRoot\..\..\Classes\CharacterSheet.ps1"

Describe "CharacterSheet" {
    Context "CharacterSheet" {
        it "Should return with Kelcey for name when instantiated without inputs" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.Name | should Be "Kelcey"
        }
        it "Should return Aspect Awesomestestest for the last aspect when instantiated without inputs" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.Aspects[-1].Name | should Be "Aspect Awesomestestest"
        }
        it "Should return Gotta-Boo-Boo for the first hinderance when instantiated without inputs" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.Hinderances[0].Name | should Be "Gotta-Boo-Boo"
        }
        it "Should return ouchy for the hinderance when instantiated without inputs" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.Hinderances[1].Name | should Be "Ouchy"
        }
        it "Should not add a hinderance type if not Resilience or ActionBonus" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.AddHinderance("Boo-Boo", "NotResilienceOrActionBonus")
            $TestCharacter.Hinderances.count | should Be 2
        }
        it "Should be count of 4 after removing an aspect" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.RemoveAspect("Aspect Awesome")
            $TestCharacter.Aspects.count | should Be 4
        }
        it "Should be count of 1 after removing boo-boos" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.RemoveHinderance("Ouchy")
            $TestCharacter.Hinderances.count | should Be 1
        }
        it "Should setcondition to 7 for body" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.SetCondition("Body", 7)
            $TestCharacter.Body.Condition | should Be 6
        }
        it "Should reset condition to 0 for body after setting to 7" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.SetCondition("Body", 7)
            $TestCharacter.ResetCondition("Body")
            $TestCharacter.Body.Condition | should Be 0
        }
        it "Showsheet() should return a boolean value of true when called" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.ShowSheet() | should Be $true
        }
        it "Should resolve the action with actioncard input" {
            $TestCharacter = [CharacterSheet]::new()
            $ActionCard = [ActionCard]::new(4, 6, @([PSCustomObject]@{Stat = "Body"; Points = -1}, [PSCustomObject]@{Stat = "Mind"; Points = -1}))

            $TestCharacter.SetActionResult($ActionCard)
            $TestCharacter.Body.Condition | should Be -2
            $TestCharacter.Mind.Condition | should Be -1
            $TestCharacter.Suffering.Points | should Be 1
            $TestCharacter.Hinderances.count | should Be 3
        }
    }
}