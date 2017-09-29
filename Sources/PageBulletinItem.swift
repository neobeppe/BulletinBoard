/**
 *  Bulletin
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import UIKit

/**
 * A standard bulletin item with a title and optional additional informations.
 */

open class PageBulletinItem: BulletinItem {

    fileprivate let interfaceFactory = BulletinInterfaceFactory()

    // MARK: Initialization

    /**
     * Creates a bulletin page with the specified title.
     *
     * - parameter title: The title of the page.
     */

    public init(title: String) {
        self.title = title
    }


    // MARK: - Page Contents

    /// The title of the page.
    public let title: String

    /// An image to display below the title. Should be 128x128px.
    public var image: UIImage?

    /// A description text to display below the image.
    public var descriptionText: String?

    /// The title of the action button.
    public var actionButtonTitle: String?

    /// The title of the ignore button.
    public var ignoreButtonTitle: String?

    /// The color to apply to buttons.
    public var tintColor: UIColor {
        get {
            return interfaceFactory.tintColor
        }
        set {
            interfaceFactory.tintColor = newValue
        }
    }


    // MARK: - Behavior

    public var manager: BulletinManager? = nil
    public var isDismissable: Bool = false

    /**
     * Whether the description text is long. If `true`, the text will be displayed with a smaller font.
     */

    public var isLongDescriptionText: Bool = false


    // MARK: - Buttons

    fileprivate var actionButton: ContainerView<HighlightButton>? = nil
    fileprivate var ignoreButton: UIButton? = nil

    /**
     * The code to execute when the action button is pressed.
     */

    public var actionHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * The code to execute when the ignore button is pressed.
     */

    public var ignoreHandler: ((PageBulletinItem) -> Void)? = nil

    /**
     * Handles a tap on the action button.
     */

    @objc open func actionButtonTapped(sender: UIButton) {
        actionHandler?(self)
    }

    /**
     * Handles a tap on the ignore button.
     */

    @objc open func ignoreButtonTapped(sender: UIButton) {
        ignoreHandler?(self)
    }


    // MARK: - View Management

    open func tearDown() {
        actionButton?.contentView.removeTarget(self, action: nil, for: .touchUpInside)
        ignoreButton?.removeTarget(self, action: nil, for: .touchUpInside)
    }

    open func makeArrangedSubviews() -> [UIView] {

        var arrangedSubviews = [UIView]()

        // Title Label

        let titleLabel = interfaceFactory.makeTitleLabel()
        titleLabel.text = title
        arrangedSubviews.append(titleLabel)

        // Image View

        if let image = self.image {

            let imageView = UIImageView()
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true

            arrangedSubviews.append(imageView)

        }

        // Description Label

        if let descriptionText = self.descriptionText {

            let descriptionLabel = interfaceFactory.makeDescriptionLabel(isCompact: isLongDescriptionText)
            descriptionLabel.text = descriptionText
            arrangedSubviews.append(descriptionLabel)

        }

        // Buttons Stack

        let buttonsStack = interfaceFactory.makeButtonsStack()

        if let actionButtonTitle = self.actionButtonTitle {

            let actionButton = interfaceFactory.makeActionButton(title: actionButtonTitle)
            buttonsStack.addArrangedSubview(actionButton)
            actionButton.contentView.addTarget(self, action: #selector(actionButtonTapped(sender:)), for: .touchUpInside)

            self.actionButton = actionButton

        }

        if let ignoreButtonTitle = self.ignoreButtonTitle {

            let ignoreButton = interfaceFactory.makeIgnoreButton(title: ignoreButtonTitle)
            buttonsStack.addArrangedSubview(ignoreButton)
            ignoreButton.addTarget(self, action: #selector(ignoreButtonTapped(sender:)), for: .touchUpInside)

            self.ignoreButton = ignoreButton

        }

        arrangedSubviews.append(buttonsStack)
        return arrangedSubviews

    }

}