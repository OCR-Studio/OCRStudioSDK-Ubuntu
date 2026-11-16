<?php 
//  Copyright (c) 2024-2026, OCR Studio
//  All rights reserved.


function main($argc, $argv) {
    if ($argc != 4) {
        printf("Version %s. Usage: %s %s <image_path_lvalue> <image_path_rvalue> <config_path>\n", 
        OCRStudioSDKInstance::LibraryVersion(), $argv[0]);
        exit(-1);
    }
    
    $image_path_lvalue = $argv[1];
    $image_path_rvalue = $argv[2];
    $config_path = $argv[3];

    printf("OCRStudioSDK version %s\n", OCRStudioSDKInstance::LibraryVersion());
    printf("image_path_lvalue = %s\n", $image_path_lvalue);
    printf("image_path_rvalue = %s\n", $image_path_rvalue);
    printf("config_path = %s\n", $config_path);
    printf("\n");

    try {
        # Creating the recognition engine object - initializes all internal
        #     configuration structure. Second parameter to the factory method
        #     is the optional JSON with initialization parameters (see documentation).
        $engine_instance = OCRStudioSDKInstance::CreateFromPath($config_path);

        # Printing Description of the created engine object.
        printf("Engine instance description:\n");
        printf("%s\n", $engine_instance->Description());
        printf("\n");

        # Parameters necessary for session creation.
        $session_params = "{";
        $session_params .= "\"session_type\": \"face_matching\", ";
        $session_params .= "\"target_group_type\": \"default\" ";
        $session_params .= "}";

        # Creating a session object - a main handle for performing
        #     face matching. Note you should put your SDK signature 
        #     verification as the first parameter.
        $session = $engine_instance->CreateSession({put_your_personalized_signature_from_doc_README.md}, $session_params);

        # Printing Description of the created session object.
        printf("Session description:\n");
        printf("%s\n", $session->Description());
        printf("\n");

        # Creating image objects which will be used for face matching.
        $image_lvalue = OCRStudioSDKImage::CreateFromFile($image_path_lvalue);
        $image_rvalue = OCRStudioSDKImage::CreateFromFile($image_path_rvalue);

        # Performing face matching between two images.
        $session->ProcessImage($image_lvalue);
        $session->ProcessImage($image_rvalue);

        # Obtaining the face matching result.
        $result = $session->CurrentResult();

        # Printing the contents of the face matching result.
        $target = $result->TargetByIndex(0);
        printf("Target description:\n");
        printf($target->Description());
        printf("\n");
        printf("Items:\n");
        $item_it = $target->ItemsBegin("string");
        while (!($item_it->IsEqualTo($target->ItemsEnd('string')))) {
            printf(" %s: %s\n", $item_it->Item()->Name(), $item_it->Item()->Value());
            $item_it->Step();
        }
    } catch (Exception $e) {
        printf("Exception thrown: %s\n", $e->getMessage());
    }
    
}

main($argc, $argv);

?>
