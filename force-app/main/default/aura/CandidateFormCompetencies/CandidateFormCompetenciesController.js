({

	doInit : function(component, event, helper) {

		var competencies = [

					{
						"label": "Droit",
						"value": "droit",
						"countCompetenciesSelected":0,
						"items": ["Affaires", "Finances","Insolvabilité","Assurances","Franchises","Propriété intellectuelle","Commerce international","Fusion et acquisition","Santé et sciences de la vie","Construction","Immigration","TI","Corporatif","Immobilier","Travail"]
					},
					{
						"label": "Comptabilité et finances",
						"value": "comptabiliteFinance",
						"countCompetenciesSelected":0,
						"items": ["Audit", "Fiscalité","Introduction en bourse","Contrôle budgétaire","Fusion et acquisition", "Présentation de l'information financière","Contrôle interne","Gestion de trésorerie","Privatisation", "Coût de revient","Gestion des risques","Redressement","Financement", "Insolvabilité et faillite","Systèmes financiers"]
					},
					{
						"label": "Informatique / T.I.",
						"value": "ti",
						"countCompetenciesSelected":0,
						"items": ["Développement de technologies, d'applications ou de logiciels", "Gestion de projet technologique","Sécurité et gestion des risques","Mobilité"]
					},
					{
						"label": "Ingénierie",
						"value": "ingenierie",
						"countCompetenciesSelected":0,
						"items": ["Aérospatial", "Électrique","Mécanique","Chimique","Industriel", "Minier","Civil","Logiciel, informatique","Physique"]
					},
					{
						"label": "Gestion des opérations",
						"value": "gestionOperations",
						"countCompetenciesSelected":0,
						"items": ["Assurance qualité", "Gestion de l'impartition","Logistique de transport","Chaînes d'approvisionnement","Gestion des inventaires", "Réseaux de distribution","Démarrage d'usine","Lean manufacturing","Robotisation et automatisation", "Gestion des indicateurs clés de performance","Logistique de production"]
					},
					{
						"label": "Ressources Humaines",
						"value": "ressourcesHumaines",
						"countCompetenciesSelected":0,
						"items": ["Développement organisationnel", "Gestion des talents et recrutement","Rémunération","Fusion, acquisition, intégration","Gestion du changement", "Santé et sécurité","Gestion de la relève","Relations de travail"]
					},
					{
						"label": "Communications",
						"value": "communications",
						"countCompetenciesSelected":0,
						"items": ["Médias sociaux", "Publicités","Relations publiques"]
					},
					{
						"label": "Ventes",
						"value": "ventes",
						"countCompetenciesSelected":0,
						"items": ["B2B", "B2C","Service à la clientèle"]
					},
					{
						"label": "Développement d'affaires / Marchés",
						"value": "devAffaires",
						"countCompetenciesSelected":0,
						"items": ["Développement de marchés", "Développement de partenariats"]
					},
					{
						"label": "Marketing",
						"value": "marketing",
						"countCompetenciesSelected":0,
						"items": ["Commerce en ligne", "Franchises","Mise en marché de nouveaux produits ou services","Commercialisation","Gestion des marques"]
					},
					{
						"label": "Planification stratégique",
						"value": "planificationStrategique",
						"countCompetenciesSelected":0,
						"items": ["Diriger l'exercice de planification", "Participer à l'exercice de planification"]
					},
					{
						"label": "Innovation",
						"value": "innovation",
						"countCompetenciesSelected":0,
						"items": ["Modèle d'affaires", "Processus","Produits","R&D"]
					},
					{
						"label": "Éthique et gouvernance",
						"value": "ethiqueGouvernance",
						"countCompetenciesSelected":0,
						"items": ["Éthique et gouvernance"]
					},
					{
						"label": "Gestion d’entreprise",
						"value": "gestionEntreprise",
						"countCompetenciesSelected":0,
						"items": ["Président(e) d’entreprise","Entrepreneur(e)","Repreneur(e)"]
					}

		];

		component.set('v.competencies',competencies);
	},

	updateInput : function(component, event, helper) {



		var competenciesSelected = component.get('v.competenciesSelected');
		var competencies = component.get('v.competencies');

		var checkBoxValue = event.getSource().get("v.value");

		if(checkBoxValue) {
			var domainSelected = checkBoxValue.split("__")[0];
			var competency = checkBoxValue.split("__")[1];

			var domainPosition = 0;
			for(var i=0;i<competencies.length;i++) {
				if(competencies[i].label==domainSelected) {
					domainPosition = i;
					break;
				}
			}


			if (competenciesSelected.hasOwnProperty(domainSelected)) {

			
				if(competenciesSelected[domainSelected].hasOwnProperty(competency)) {
					delete competenciesSelected[domainSelected][competency];
					competencies[domainPosition].countCompetenciesSelected = competencies[domainPosition].countCompetenciesSelected-1;
				} else {
					competenciesSelected[domainSelected][competency] = true;
					competencies[domainPosition].countCompetenciesSelected = competencies[domainPosition].countCompetenciesSelected+1;
				}

			} else {
				competenciesSelected[domainSelected] = {};
				competenciesSelected[domainSelected][competency] = true;
				competencies[domainPosition].countCompetenciesSelected = competencies[domainPosition].countCompetenciesSelected+1;
			}

			var item = {};
			item["domains"] = [];
			var competenciesArray = Object.keys(competenciesSelected);
			
			if(competenciesArray) {
				var nbDomainSelected = 0;
				for(var i=0;i<competenciesArray.length;i++) {
					if(Object.keys(competenciesSelected[competenciesArray[i]]).length>0) {
						var domainObj = {};
						domainObj.name = competenciesArray[i];
						domainObj.competencies =  Object.keys(competenciesSelected[competenciesArray[i]]);

						item["domains"].push(domainObj);
						nbDomainSelected++;
					}
				}
				
				
				if(nbDomainSelected>2) {
					var elements = component.find("cmpCheckbox");
					for(var i=0;i<elements.length;i++) {
						if(elements[i].get('v.name')==checkBoxValue) {
							elements[i].set('v.checked',false);
							break;
						}
					}

					competenciesSelected[domainSelected] = {};
					competencies[domainPosition].countCompetenciesSelected = 0;

					alert("Vous ne pouvez pas sélectionner plus de deux domaines d'expertise");
				} else {
					
					component.set('v.competencies',competencies);
					component.set('v.competenciesSelected',competenciesSelected);

					var eventSelected = $A.get("e.c:CandidateInputUpdateEvt");
				    eventSelected.setParams({ "item": item}).fire();
				}
			}
	
		}
	}
})