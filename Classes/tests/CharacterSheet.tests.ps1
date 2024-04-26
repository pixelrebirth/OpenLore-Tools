. "$PSScriptRoot\..\..\Classes\CharacterSheet.ps1"

Describe "CharacterSheet" {
    Context "CharacterSheet" {
        it "Should return with J. Doe for name when instantiated without inputs" {
            $TestCharacter = [CharacterSheet]::new()
            $TestCharacter.Name | should Be "J. Doe"
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
            $ActionCard = [ActionCard]::new(4, 6, @([PSCustomObject]@{Stat = "Body"; Points = -1}, [PSCustomObject]@{Stat = "Mind"; Points = -1}), "Body")

            $TestCharacter.SetActionResult($ActionCard)
            $TestCharacter.Body.Condition | should Be -3
            $TestCharacter.Mind.Condition | should Be -2
            $TestCharacter.Suffering.Points | should Be 1
            $TestCharacter.Hinderances.count | should Be 3
        }
        It "Refreshes hinderance counts correctly" {
            $character = [CharacterSheet]::new()
            $character.AddHinderance("ResilienceBooBoo", "Resilience")
            $character.AddHinderance("ActionBooBoo", "ActionBonus")
            $character.RefreshHinderanceCounts()
            $character.HinderanceTypeResilienceCount | Should Be 2
            $character.HinderanceTypeActionBonusCount | Should Be 2
        }
        It "Resolves suffering to hinderances correctly" {
            $character = [CharacterSheet]::new()
            $character.Suffering.Points = 10
            $character.Resilience = 5
            $character.ResolveSufferingToHinderances()
            $character.Suffering.Points | Should Be 5
            $character.Hinderances.Count | Should Be 3
        }
        It "Applies impact correctly" {
            $character = [CharacterSheet]::new()
            $actionCard = [ActionCard]::new(4, 6, @([PSCustomObject]@{Stat = "Body"; Points = -1}), "Body")
            $character.SetActionResult($actionCard)
            $character.Suffering.Points | Should Be 1
        }
    }
    Context "ActionCard" {
        it "Should return a body stat of -1 when ActionCard is created with -1 body condition" {
            $TestActionCard = [ActionCard]::new(4, 6, @([PSCustomObject]@{Stat = "Body"; Points = -1}), "Body")
            $TestActionCard.Chance | should Be 4
            $TestActionCard.Impact | should Be 6
            $TestActionCard.ConditionsArray[0].Stat | should Be "Body"
            $TestActionCard.ConditionsArray[0].Points | should Be -1
        }
        it "Should settarget correctly" {
            $TestActionCard = [ActionCard]::new(4, 6, @([PSCustomObject]@{Stat = "Body"; Points = -1}), "Body")
            $TestActionCard.SetTarget(5,7)
            $TestActionCard.Threshold | should Be 12
        }
    }
    Context "DiceMechanics" {
        it "Should create a RollResult for all combinations of chance input 1 thru 31" {
            $TestDiceMechanics = 1..31 | Foreach-Object {[DiceMechanics]::new($_)}
            $TestDiceMechanics.count | should Be 31
            ($TestDiceMechanics.Sides | Measure-Object -Sum).Sum | should Be 992
        }
        it "Should treat the chance input as 31 if greater than 31" {
            [DiceMechanics]::new(32).Count | should Be 1
        }
    }
}