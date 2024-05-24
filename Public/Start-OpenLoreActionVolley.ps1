. "$PSScriptRoot\..\Classes\CharacterSheet.ps1"
function Start-OpenLoreActionVolley {
    [CmdletBinding()]
    param (
        $VolleysInSequence,
        $Character_A = [CharacterSheet]::new(),
        $A_ActionChance = 8,
        $A_ActionImpact = 10,
        $A_CapabilityTarget = "Body",
        $A_ThresholdAspect = 9,
        $Character_B = [CharacterSheet]::new(),
        $B_ActionChance = 7,
        $B_ActionImpact = 10,
        $B_CapabilityTarget = "Body",
        $B_ThresholdAspect = 10
    )

    $A_Capability = $Character_A.Capabilities.$A_CapabilityTarget.Points
    $B_Capability = $Character_B.Capabilities.$B_CapabilityTarget.Points

    1..$VolleysInSequence | ForEach-Object {
        $ActionCard = [ActionCard]::new($A_ActionChance, $A_ActionImpact, $null, $B_CapabilityTarget)
        $ActionCard.SetThreshold($B_Capability,$B_ThresholdAspect)
        $ActionCard.RollAction($Character_B)
        $Character_B.SetActionResult($A_ActionCard)

        $ActionCard = [ActionCard]::new($B_ActionChance, $B_ActionImpact, $null, $A_CapabilityTarget)
        $ActionCard.SetThreshold($A_Capability,$A_ThresholdAspect)
        $ActionCard.RollAction($Character_A)
        $Character_A.SetActionResult($B_ActionCard)
    }

    #Change this to a more robust output with PSCustomObject
    [PSCustomObject]@{
        A_Hinderances = $Character_A.Hinderances.Count
        A_Suffering = $Character_A.Suffering.Points
        A_TotalSuffering = ($Character_A.Resilience * $Character_A.Hinderances.Count) + $Character_A.Suffering.Points
        B_Hinderances = $Character_B.Hinderances.Count
        B_Suffering = $Character_B.Suffering.Points
        B_TotalSuffering = ($Character_B.Resilience * $Character_B.Hinderances.Count) + $Character_B.Suffering.Points
    }
}

$GetTotals = 1..1000 | Foreach-Object {
    start-sleep -Milliseconds 10 #Used to improve the psuedo-randomness of the dice rolls
    Start-OpenLoreActionVolley -VolleysInSequence 1
}

$GetTotals | Select-Object  A_TotalSuffering, B_TotalSuffering | Measure-Object -Property A_TotalSuffering, B_TotalSuffering -Average -Sum -Maximum -Minimum -StandardDeviation