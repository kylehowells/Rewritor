//
//  SwiftUIPreviewView.swift
//  Rewritor
//
//  Created by Kyle Howells on 26/08/2020.
//

import SwiftUI

struct VCRepresentable<VCClass:UIViewController>: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		return VCClass()
	}
}

struct VCDocRepresentable: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		let navController = UINavigationController()
		let docVC = DocumentViewController();
		docVC.navigationItem.title = "Preview.txt";
		docVC.view.textView.text = "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They're not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. About the only thing you can't do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, we see genius. Because the people who are crazy enough to think they can change the world, are the ones who do.";
		navController.pushViewController(docVC, animated: false)
		return navController
	}
}

struct NavWrappedVCRepresentable<VCClass:UIViewController>: UIViewControllerRepresentable {
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
		// leave this empty
	}
	
	@available(iOS 13.0.0, *)
	func makeUIViewController(context: Context) -> UIViewController {
		let navController = UINavigationController()
		navController.pushViewController(VCClass(), animated: false)
		return navController
	}
}

struct SwiftUIView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			VCDocRepresentable()
				.edgesIgnoringSafeArea(.all)
				.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
		
			/*NavWrappedVCRepresentable<SettingsViewController>()
			.edgesIgnoringSafeArea(.all)
			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
			.environment(\.colorScheme, .light)
			
			NavWrappedVCRepresentable<SettingsViewController>()
			.edgesIgnoringSafeArea(.all)
			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
			.environment(\.colorScheme, .dark)*/
		}
	}
}
