//
//  InfoDetailViewController.swift
//  Donando
//
//  Created by Halil Gursoy on 17/07/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import UIKit

public class InfoDetailViewController: UIViewController {
    
    @IBOutlet weak var infoDetailTextView: UITextView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupDetailLabel()
        
        title = "Info"
    }
    
    func setupDetailLabel() {
        infoDetailTextView.text = "Was ist Donando?Donando unterstützt dich bei der Kleiderspende und zeigt dir, bei welchen Organisationen du in deiner Nähe Kleidung und andere Sachen spenden kannst. Wer und warum?\n\nWir sind eine Gruppe von Kollegen und wollten Anfang des Jahres unsere Kleidung für wohltätige Zwecke spenden - und wussten nicht wo. Erst nach längerer Recherche im Internet sind wir auf einige Presseartikel und Facebook-Gruppen gestoßen, in denen Informationen darüber zu finden waren, wo man spenden konnte. Wir dachten, das geht auch einfacher und so schlossen wir uns zusammen, um diese App & Webseite zu entwickeln. Wir suchen UnterstützungWenn du weitere Organisationen kennst, bei denen man Kleidung spenden kann, schick uns bitte den Namen der Organisation, die Adresse, benötigte Spenden (oder einen Link zur Bedarfsliste) und einen Link zu deren Webseite.\n\nDarüber hinaus suchen wir nach Web- und iOS- Entwicklern, die uns dabei helfen können, Donando weiterzuentwickeln."

    }
}
