--
-- Culture Scaling
--

UPDATE Traits
SET CultureFromKills = 3 * CultureFromKills;

UPDATE Traits
SET CityCultureBonus = 1.5 * CityCultureBonus;

UPDATE Eras
SET StartingCulture = 2 * StartingCulture;

UPDATE Improvement_Yields
SET Yield = 2
WHERE YieldType = 'YIELD_CULTURE' AND ImprovementType = 'IMPROVEMENT_MOAI';

UPDATE Improvements
SET CultureAdjacentSameType = 2 * CultureAdjacentSameType;

UPDATE Policies
SET CulturePerGarrisonedUnit = 2 * CulturePerGarrisonedUnit;



--
-- Misc
--

INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_INSPIRATION', 
	BuildingClass, 
	'YIELD_CULTURE',
	2
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_SHRINE',
	'BUILDINGCLASS_TEMPLE',
	'BUILDINGCLASS_PAGODA',
	'BUILDINGCLASS_CATHEDRAL',
	'BUILDINGCLASS_MONASTERY',
	'BUILDINGCLASS_MOSQUE'
);

INSERT INTO Policy_BuildingClassYieldModifiers(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldMod)
SELECT DISTINCT
	'POLICY_CHARITY', 
	BuildingClass, 
	'YIELD_GOLD',
	5
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_SHRINE',
	'BUILDINGCLASS_TEMPLE',
	'BUILDINGCLASS_PAGODA',
	'BUILDINGCLASS_CATHEDRAL',
	'BUILDINGCLASS_MONASTERY',
	'BUILDINGCLASS_MOSQUE'
);

INSERT INTO Policy_BuildingClassProductionModifiers
	(PolicyType, BuildingClassType,  ProductionModifier)
SELECT DISTINCT
	'POLICY_MILITARY_TRADITION', BuildingClass, 10
FROM Buildings WHERE (
	Defense > 0
	OR GlobalDefenseMod > 0 
	OR Experience > 0
	OR GlobalExperience > 0
	OR Type IN (SELECT BuildingType FROM Building_DomainFreeExperiences)
	OR Type IN (SELECT BuildingType FROM Building_DomainProductionModifiers)
	OR Type IN (SELECT BuildingType FROM Building_UnitCombatFreeExperiences)
	OR Type IN (SELECT BuildingType FROM Building_UnitCombatProductionModifiers)
);

/*
INSERT INTO Policy_BuildingClassProductionModifiers(
	PolicyType, 
	BuildingClassType, 
	ProductionModifier)
SELECT DISTINCT
	'POLICY_DEMOCRACY', 
	BuildingClass, 
	20
FROM Buildings WHERE (
	SpecialistCount > 0
);
*/

/*
INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_ORDER_FINISHER', 
	BuildingClass, 
	'YIELD_PRODUCTION',
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_SPACESHIP_FACTORY',
	'BUILDINGCLASS_HYDRO_PLANT',
	'BUILDINGCLASS_SOLAR_PLANT',
	'BUILDINGCLASS_NUCLEAR_PLANT'
);
*/

INSERT INTO Policy_BuildingClassYieldModifiers(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldMod)
SELECT DISTINCT
	'POLICY_ORDER_FINISHER', 
	BuildingClass, 
	'YIELD_PRODUCTION',
	10
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_SPACESHIP_FACTORY',
	'BUILDINGCLASS_HYDRO_PLANT',
	'BUILDINGCLASS_SOLAR_PLANT',
	'BUILDINGCLASS_NUCLEAR_PLANT'
);

INSERT INTO Policy_ImprovementYieldChanges
	(PolicyType, ImprovementType, YieldType, Yield)
SELECT
	'POLICY_FREE_SPEECH', 'IMPROVEMENT_MOAI', 'YIELD_CULTURE', '2'
WHERE EXISTS (SELECT * FROM Improvements WHERE Type='IMPROVEMENT_MOAI' );

INSERT INTO Policy_BuildingClassHappiness
	(PolicyType, BuildingClassType, Happiness)
SELECT DISTINCT
	'POLICY_TRADITION_FINISHER', BuildingClass, 1
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
) AND NOT BuildingClass IN (
	SELECT BuildingClass FROM Buildings WHERE IsVisible = 0
);

INSERT INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT
	'POLICY_ARISTOCRACY', BuildingClass, 'YIELD_CULTURE', 4
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
) AND NOT BuildingClass IN (
	SELECT BuildingClass FROM Buildings WHERE IsVisible = 0
);