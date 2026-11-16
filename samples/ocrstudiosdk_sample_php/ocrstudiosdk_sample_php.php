<?php 
//  Copyright (c) 2024-2026, OCR Studio
//  All rights reserved.


function main($argc, $argv) {
    if ($argc != 4) {
        printf("Version %s. Usage: %s %s <image_path> <config_path> <target_mask>\n", 
        OCRStudioSDKInstance::LibraryVersion(), $argv[0]);
        exit(-1);
    }
    
    $image_path = $argv[1];
    $config_path = $argv[2];
    $target_mask = $argv[3];

    printf("OCRStudioSDK version %s\n", OCRStudioSDKInstance::LibraryVersion());
    printf("image_path = %s\n", $image_path);
    printf("config_path = %s\n", $config_path);
    printf("target_mask = %s\n", $target_mask);
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
        $session_params .= "\"session_type\": \"document_recognition\", ";
        $session_params .= "\"target_group_type\": \"default\", ";
        $session_params .= "\"target_masks\": \"" . $target_mask . "\", ";
        $session_params .= "\"output_modes\": [";
        $session_params .= "\"character_alternatives\", ";
        $session_params .= "\"field_geometry\" ";
        $session_params .= "] ";
        $session_params .= "}";

        # Creating a session object - a main handle for performing recognition.
        #   Note you should put your SDK signature verification as the first parameter.
        $session = $engine_instance->CreateSession({put_your_personalized_signature_from_doc_README.md}, $session_params);

        # Printing Description of the created session object.
        printf("Session description:\n");
        printf("%s\n", $session->Description());
        printf("\n");

        # Creating an image object which will be used as an input for the session.
        $image = OCRStudioSDKImage::CreateFromFile($image_path);

        # Performing the recognition.
        $session->ProcessImage($image);

        # Obtaining the recognition result.
        $result = $session->CurrentResult();

        # Printing the contents of the recognition result.
        printf("Targets count: %s\n", $result->TargetsCount());
        for($i = 0; $i < $result->TargetsCount(); $i++) {
            $target = $result->TargetByIndex($i);
            printf("Target %s description:\n", $i);
            printf("%s\n", $target->Description());
            printf("\n");
            printf("Number of strings: %s\n", $target->ItemsCountByType('string'));
            printf("Strings:\n");
            $item_it = $target->ItemsBegin('string');
            while (!($item_it->IsEqualTo($target->ItemsEnd('string')))) {
                printf(" %s: %s\n", $item_it->Item()->Name(), $item_it->Item()->Description());
                printf("\n");
                $item_it->Step();
            }
            printf("Is target final: %s\n", $target->IsFinal() ? 'true' : 'false');
            printf("\n");
            printf("Is result final: %s\n", $result->AllTargetsFinal() ? 'true' :'false');
        }

    } catch (Exception $e) {
        printf("Exception thrown: %s\n", $e->getMessage());
    }
    
}

main($argc, $argv);

?>
