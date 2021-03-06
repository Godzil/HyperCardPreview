//
//  HyperCardFileStack.swift
//  HyperCard
//
//  Created by Pierre Lorenzi on 26/02/2017.
//  Copyright © 2017 Pierre Lorenzi. All rights reserved.
//


public extension Stack {
    
    public convenience init(fileContent: HyperCardFileData, resources: ResourceRepository?) {
        
        self.init()
        
        /* Register the resources */
        self.resources = resources
        
        /* Enable lazy initialization */
        let stackBlock = fileContent.stack
        
        /* Read now the scalar fields */
        self.passwordHash = stackBlock.passwordHash
        self.userLevel = stackBlock.userLevel
        self.cantAbort = stackBlock.cantAbort
        self.cantDelete = stackBlock.cantDelete
        self.cantModify = stackBlock.cantModify
        self.cantPeek = stackBlock.cantPeek
        self.privateAccess = stackBlock.privateAccess
        self.versionAtCreation = stackBlock.versionAtCreation
        self.versionAtLastCompacting = stackBlock.versionAtLastCompacting
        self.versionAtLastModificationSinceLastCompacting = stackBlock.versionAtLastModificationSinceLastCompacting
        self.versionAtLastModification = stackBlock.versionAtLastModification
        self.size = stackBlock.size
        self.windowRectangle = stackBlock.windowRectangle
        self.screenRectangle = stackBlock.screenRectangle
        self.scrollPoint = stackBlock.scrollPoint
        
        /* Cards */
        self.cardsProperty.lazyCompute = {
            let cardBlocks = fileContent.cards
            return cardBlocks.map({ [unowned self] in return self.wrapCardBlock(cardBlock: $0, fileContent: fileContent) })
        }
        
        /* Backgrounds */
        self.backgroundsProperty.lazyCompute = {
            let backgroundBlocks = fileContent.backgrounds
            return backgroundBlocks.map({ (block: BackgroundBlock) -> Background in
                return Background(backgroundBlock: block, fileContent: fileContent)
            })
        }
        
        /* patterns */
        self.patternsProperty.lazyCompute = {
            return stackBlock.patterns
        }
        
        /* script */
        self.scriptProperty.lazyCompute = {
            return stackBlock.script
        }
        
        /* font names */
        self.fontNameReferencesProperty.lazyCompute = {
            return fileContent.fontBlock?.fontReferences ?? []
        }

        
    }
    
    private func wrapCardBlock(cardBlock: CardBlock, fileContent: HyperCardFileData) -> Card {
        
        /* Find the card background */
        let backgroundIdentifer = cardBlock.backgroundIdentifier
        let backgroundIndex = self.backgrounds.index(where: {$0.identifier == backgroundIdentifer})!
        let background = self.backgrounds[backgroundIndex]
        
        /* Build the card */
        return Card(cardBlock: cardBlock, fileContent: fileContent, background: background)
    }
    
}

