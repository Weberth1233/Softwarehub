package com.nitssrpi.NIT_SRPI.controller;

import com.nitssrpi.NIT_SRPI.model.ChangeRequestAttachment;
import com.nitssrpi.NIT_SRPI.service.ChangeRequestAttachmentService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/change-request-attachments")
public class ChangeRequestAttachmentController {

    private final ChangeRequestAttachmentService service;

    public ChangeRequestAttachmentController(ChangeRequestAttachmentService service) {
        this.service = service;
    }

    @PostMapping(
            value = "/upload",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    public ResponseEntity<ChangeRequestAttachment> upload(
            @RequestParam("file") MultipartFile file
    ) {
        ChangeRequestAttachment attachment = service.upload(file);
        return ResponseEntity.ok(attachment);
    }
}