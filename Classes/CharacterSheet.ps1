class CharacterSheet {
    [string] $Name
    [string] $Pronouns
    [string] $Appearance
    [string] $Backstory
    [PSCustomObject] $Body
    [PSCustomObject] $Mind
    [PSCustomObject] $Supernatural
    [PSCustomObject] $Intuition
    [PSCustomObject] $Perception
    [PSCustomObject] $Communication
    [PSCustomObject] $Heart
    [PSCustomObject] $Willpower
    [PSCustomObject] $Survival
    [PSCustomObject] $Charisma
    [PSCustomObject] $Suffering
    [int] $Resilience
    [int] $ActionBonus
    [PSCustomObject] $Hinderances
    [int] $HinderanceTypeResilienceCount
    [int] $HinderanceTypeActionBonusCount
    [PSCustomObject] $Aspects
    [int] $Essence

    CharacterSheet (){
        $this.Name = "J. Doe"
        $this.Pronouns = "any/all"
        $this.Appearance = "Perfectly average in every way."
        $this.Backstory = "A person who is a person."

        [PsCustomObject] $this.Suffering =      @{ Points = 0 ; Condition = 0 }
        [PsCustomObject] $this.Body =           @{ Points = 1 ; Condition = 0 }
        [PsCustomObject] $this.Mind =           @{ Points = 3 ; Condition = 0 }
        [PsCustomObject] $this.Supernatural =   @{ Points = 5 ; Condition = 0 }
        [PsCustomObject] $this.Intuition =      @{ Points = 1 ; Condition = 0 }
        [PsCustomObject] $this.Perception =     @{ Points = 2 ; Condition = 0 }
        [PsCustomObject] $this.Communication =  @{ Points = 3 ; Condition = 0 }
        [PsCustomObject] $this.Heart =          @{ Points = 4 ; Condition = 0 }
        [PsCustomObject] $this.Willpower =      @{ Points = 5 ; Condition = 0 }
        [PsCustomObject] $this.Survival =       @{ Points = 6 ; Condition = 0 }
        [PsCustomObject] $this.Charisma =       @{ Points = 7 ; Condition = 0 }

        $this.Essence = 5
        $this.Resilience = 5
        $this.ActionBonus = 5
        $this.Aspects = New-Object System.Collections.ArrayList
        $this.Hinderances = New-Object System.Collections.ArrayList

        $this.AddAspect("Aspect Awesome", 5, 0)
        $this.AddAspect("Aspect Awesomer", 4, 0)
        $this.AddAspect("Aspect Awesomest", 3, 0)
        $this.AddAspect("Aspect Awesomestest", 2, 0)
        $this.AddAspect("Aspect Awesomestestest", 1, 0)

        $this.AddHinderance("Gotta-Boo-Boo", "Resilience")
        $this.AddHinderance("Ouchy", "ActionBonus")
        $this.RefreshHinderanceCounts()

        $this.SetCondition("Body",-1)
    }

    [void] SetCondition ($Stat, $Points){
        $this.$Stat.Condition = $this.$Stat.Condition + $Points
    }

    [void] ResetCondition ($Stat){
        $this.$Stat.Condition = 0
    }

    [void] AddAspect ([string]$Name, [int]$Points, [int]$Uses){
        $this.Aspects += [PSCustomObject]@{
            Name = $Name
            Points = $Points
            Uses = $Uses
        }
    }
    [void] RemoveAspect ([string]$Name){
        $this.Aspects = $this.Aspects | Where-Object { $_.Name -ne $Name }
    }

    [void] AddHinderance ([string]$Name, [string]$Type){
        $Types = @("Resilience", "ActionBonus", "ChooseRandom")
        if ($Type -in $Types){
            if ($Type -eq "ChooseRandom"){$Type = $Types | Get-Random}
            $this.Hinderances += [PSCustomObject]@{
                Name = $Name
                Type = $Type
            }
        }
        $this.RefreshHinderanceCounts()
    }
    [void] RemoveHinderance ([string]$Name){
        $this.Hinderances = $this.Hinderances | Where-Object { $_.Name -ne $Name }
        $this.RefreshHinderanceCounts()
    }

    [void] RefreshHinderanceCounts (){
        $this.HinderanceTypeResilienceCount = ($this.Hinderances | Where-Object { $_.Type -eq "Resilience" }).Count
        $this.HinderanceTypeActionBonusCount = ($this.Hinderances | Where-Object { $_.Type -eq "ActionBonus" }).Count
    }

    [void] ResolveSufferingToHinderances (){
        if ($this.Suffering.Points -ge $this.Resilience){
            $this.Suffering.Points = $this.Suffering.Points - $this.Resilience
            $this.AddHinderance("NoContext", "ChooseRandom")
        }
    }

    [void] ApplyImpact ([ActionCard]$ActionCard) {
        $this.Suffering.Points = $this.Suffering.Condition + $this.Suffering.Points + $ActionCard.Impact #Condition for suffering resolves on impact
        $this.ResetCondition("Suffering")

        $this.ResolveSufferingToHinderances()

        foreach ($Condition in $ActionCard.ConditionsArray){
            $this.SetCondition($Condition.Stat, $Condition.Points)
        }
    }

    [void] SetActionResult ([ActionCard]$ActionCard){
        $this.ApplyImpact($ActionCard)
        foreach ($Condition in $ActionCard.ConditionsArray){
            $this.SetCondition($Condition.Stat, $Condition.Points)
        }
    }

    [bool] ShowSheet (){
        Write-Host @"
Name: $($this.Name)
Pronouns: $($this.Pronouns)
Appearance: $($this.Appearance)
Backstory: $($this.Backstory)
---
Resilience: $($this.Resilience) [-$($this.HinderanceTypeResilienceCount)]
ActionBonus: $($this.ActionBonus) [-$($this.HinderanceTypeActionBonusCount)]
---
Capabilities:
    Body: $($this.Body.Points) [$($this.Body.Condition)]
    Mind: $($this.Mind.Points) [$($this.Mind.Condition)]
    Supernatural: $($this.Supernatural.Points) [$($this.Supernatural.Condition)]
---
Essence:
Attributes:
    Intuition: $($this.Intuition.Points) [$($this.Intuition.Condition)]
    Perception: $($this.Perception.Points) [$($this.Perception.Condition)]
    Communication: $($this.Communication.Points) [$($this.Communication.Condition)]
    Heart: $($this.Heart.Points) [$($this.Heart.Condition)]
    Willpower: $($this.Willpower.Points) [$($this.Willpower.Condition)]
    Survival: $($this.Survival.Points) [$($this.Survival.Condition)]
    Charisma: $($this.Charisma.Points) [$($this.Charisma.Condition)]
---
Aspects:
 $($this.Aspects | ForEach-Object { "  $($_.Name) - $($_.Points) [$($_.Uses) uses]`n" })
Hinderances:
 $($this.Hinderances | ForEach-Object { "  $($_.Name) - $($_.Type) type.`n" })
"@
        return $true
    }
    # Usage: [CharacterSheet]::new()
}

class ActionCard {
    [int] $Chance
    [int] $Impact
    [PSCustomObject[]] $ConditionsArray
    [string] $TargettedCapability
    [int] $Threshold

    ActionCard (){}

    ActionCard ([int] $Chance, [int] $Impact, [PSCustomObject[]] $ConditionsArray, $TargettedCapability){
        $this.SetActor($Chance, $Impact, $ConditionsArray, $TargettedCapability)
    }

    [void] SetActor ([int] $Chance, [int] $Impact, [PSCustomObject[]] $ConditionsArray, $TargettedCapability){
        $this.Chance = $Chance
        $this.Impact = $Impact
        $this.ConditionsArray = $ConditionsArray
        $this.TargettedCapability = $TargettedCapability
    }

    [void] SetTarget ([int] $CapabilityScore, [int] $AspectScore){
        $this.Threshold = $AspectScore + $CapabilityScore
    }
    # Usage: [ActionCard]::new(4, 3, @([PSCustomObject]@{Stat = "Body"; Points = -1}, [PSCustomObject]@{Stat = "Mind"; Points = -1}), "Body")
}

class DiceMechanics {
    [int] $Sides
    [array] $DiceSet
    [array] $EachResult
    [int] $RollResult
    DiceMechanics ([int] $Chance){
        if ($Chance -gt 31){$Chance = 31}
        $this.Sides = $Chance * 2
        $SideChoices = @(2,4,6,8,10,12,20)
        $Total = 0
        $this.DiceSet = @()
        $this.EachResult = @()
        while ($True){
            1..100 | Foreach-Object {
                $SideChoices | Get-Random | Foreach-Object {
                    $CurrentSide = $_
                    $TestTotal = $Total + $CurrentSide
                    if ($TestTotal -le $this.Sides -AND $_ -notin $this.DiceSet){
                        $this.DiceSet += $_
                        $Total += $_
                        continue
                    }
                }
            }
            if ($Total -eq $this.Sides){
                $this.DiceSet | Foreach-Object {
                    $this.EachResult += 1..$_ | Get-Random
                }
                $this.RollResult = ($this.EachResult | Measure-Object -Sum).Sum
                break
            }
            else {
                $this.DiceSet = @()
                $Total = 0
            }
        }
    }
}